import SwiftUI

/// Build a SwiftUI `Path` from an SVG path-data string (the `d` attribute).
///
/// The RN pets author face/body geometry as SVG `d` strings (`react-native-svg`
/// `<Path d=... />`). Porting them 1:1 means parsing that same string here, so a
/// pet's `d` can be pasted verbatim in Steps 8–15. Supports the command subset
/// the pets actually use: `M/m L/l H/h V/v C/c Q/q A/a Z/z` (absolute + relative).
func svgPath(_ d: String) -> Path {
    var path = Path()
    var scanner = PathScanner(d)
    var current = CGPoint.zero
    var start = CGPoint.zero
    var prevControl: CGPoint? = nil // for smooth curves (T/S) — unused today but cheap
    var command: Character = " "

    func num() -> CGFloat { CGFloat(scanner.number()) }
    func point(relative: Bool) -> CGPoint {
        let x = num(), y = num()
        return relative ? CGPoint(x: current.x + x, y: current.y + y) : CGPoint(x: x, y: y)
    }

    while let cmd = scanner.command() {
        command = cmd
        let relative = cmd.isLowercase
        switch Character(cmd.lowercased()) {
        case "m":
            current = point(relative: relative)
            path.move(to: current)
            start = current
            // Subsequent coordinate pairs after M are implicit L (per SVG spec).
            while scanner.peekIsNumber() {
                current = point(relative: relative)
                path.addLine(to: current)
            }
        case "l":
            repeat {
                current = point(relative: relative)
                path.addLine(to: current)
            } while scanner.peekIsNumber()
        case "h":
            repeat {
                let x = num()
                current = CGPoint(x: relative ? current.x + x : x, y: current.y)
                path.addLine(to: current)
            } while scanner.peekIsNumber()
        case "v":
            repeat {
                let y = num()
                current = CGPoint(x: current.x, y: relative ? current.y + y : y)
                path.addLine(to: current)
            } while scanner.peekIsNumber()
        case "c":
            repeat {
                let c1 = point(relative: relative)
                let c2 = point(relative: relative)
                let end = point(relative: relative)
                path.addCurve(to: end, control1: c1, control2: c2)
                prevControl = c2
                current = end
            } while scanner.peekIsNumber()
        case "q":
            repeat {
                let c = point(relative: relative)
                let end = point(relative: relative)
                path.addQuadCurve(to: end, control: c)
                prevControl = c
                current = end
            } while scanner.peekIsNumber()
        case "a":
            repeat {
                let rx = num(), ry = num()
                let xRotation = num()
                let largeArc = num() != 0
                let sweep = num() != 0
                let end = point(relative: relative)
                addArc(to: &path, from: current, to: end, rx: rx, ry: ry, xRotationDeg: xRotation, largeArc: largeArc, sweep: sweep)
                current = end
            } while scanner.peekIsNumber()
        case "z":
            path.closeSubpath()
            current = start
        default:
            break
        }
        _ = command
        _ = prevControl
    }

    return path
}

/// A SwiftUI `Shape` wrapper so a parsed path can be styled with `.fill`/`.stroke`.
struct SVGShape: Shape {
    let d: String
    func path(in rect: CGRect) -> Path { svgPath(d) }
}

// MARK: - Elliptical-arc → cubic Béziers

/// Append an SVG elliptical arc (`A`) as one or more cubic Bézier segments —
/// SwiftUI `Path` has no native elliptical-arc-to. Standard endpoint→center
/// parameterization (SVG impl notes, F.6).
private func addArc(
    to path: inout Path,
    from p0: CGPoint,
    to p1: CGPoint,
    rx rxIn: CGFloat,
    ry ryIn: CGFloat,
    xRotationDeg: CGFloat,
    largeArc: Bool,
    sweep: Bool
) {
    if rxIn == 0 || ryIn == 0 {
        path.addLine(to: p1)
        return
    }
    var rx = abs(rxIn)
    var ry = abs(ryIn)
    let phi = xRotationDeg * .pi / 180
    let cosPhi = cos(phi), sinPhi = sin(phi)

    let dx = (p0.x - p1.x) / 2
    let dy = (p0.y - p1.y) / 2
    let x1p = cosPhi * dx + sinPhi * dy
    let y1p = -sinPhi * dx + cosPhi * dy

    // Scale radii up if too small to span the endpoints.
    let lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry)
    if lambda > 1 {
        let s = sqrt(lambda)
        rx *= s
        ry *= s
    }

    let sign: CGFloat = (largeArc != sweep) ? 1 : -1
    let num = rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p
    let den = rx * rx * y1p * y1p + ry * ry * x1p * x1p
    let co = sign * sqrt(max(0, num / den))
    let cxp = co * (rx * y1p) / ry
    let cyp = co * -(ry * x1p) / rx

    let cx = cosPhi * cxp - sinPhi * cyp + (p0.x + p1.x) / 2
    let cy = sinPhi * cxp + cosPhi * cyp + (p0.y + p1.y) / 2

    func angle(_ ux: CGFloat, _ uy: CGFloat, _ vx: CGFloat, _ vy: CGFloat) -> CGFloat {
        let dot = ux * vx + uy * vy
        let len = sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy))
        var a = acos(min(1, max(-1, dot / len)))
        if ux * vy - uy * vx < 0 { a = -a }
        return a
    }

    let theta1 = angle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry)
    var deltaTheta = angle((x1p - cxp) / rx, (y1p - cyp) / ry, (-x1p - cxp) / rx, (-y1p - cyp) / ry)
    if !sweep && deltaTheta > 0 { deltaTheta -= 2 * .pi }
    if sweep && deltaTheta < 0 { deltaTheta += 2 * .pi }

    // Split into ≤90° segments for accurate cubic approximation.
    let segments = max(1, Int(ceil(abs(deltaTheta) / (.pi / 2))))
    let delta = deltaTheta / CGFloat(segments)
    let t = 4 / 3 * tan(delta / 4)

    var theta = theta1
    for _ in 0..<segments {
        let cosT1 = cos(theta), sinT1 = sin(theta)
        let cosT2 = cos(theta + delta), sinT2 = sin(theta + delta)

        func pointAt(_ c: CGFloat, _ s: CGFloat) -> CGPoint {
            CGPoint(
                x: cx + cosPhi * (rx * c) - sinPhi * (ry * s),
                y: cy + sinPhi * (rx * c) + cosPhi * (ry * s)
            )
        }
        func deriv(_ c: CGFloat, _ s: CGFloat) -> CGPoint {
            CGPoint(
                x: cosPhi * (-rx * s) - sinPhi * (ry * c),
                y: sinPhi * (-rx * s) + cosPhi * (ry * c)
            )
        }

        let endPt = pointAt(cosT2, sinT2)
        let d1 = deriv(cosT1, sinT1)
        let d2 = deriv(cosT2, sinT2)
        let p1Start = pointAt(cosT1, sinT1)
        let c1 = CGPoint(x: p1Start.x + t * d1.x, y: p1Start.y + t * d1.y)
        let c2 = CGPoint(x: endPt.x - t * d2.x, y: endPt.y - t * d2.y)
        path.addCurve(to: endPt, control1: c1, control2: c2)
        theta += delta
    }
}

// MARK: - Tokenizer

/// Minimal SVG path-data tokenizer: walks the string yielding command letters
/// and numbers, tolerating the usual whitespace/comma separators.
private struct PathScanner {
    private let chars: [Character]
    private var i = 0

    init(_ s: String) { chars = Array(s) }

    private mutating func skipSeparators() {
        while i < chars.count {
            let c = chars[i]
            if c == " " || c == "," || c == "\n" || c == "\t" || c == "\r" {
                i += 1
            } else {
                break
            }
        }
    }

    mutating func command() -> Character? {
        skipSeparators()
        guard i < chars.count else { return nil }
        let c = chars[i]
        if c.isLetter {
            i += 1
            return c
        }
        return nil
    }

    mutating func peekIsNumber() -> Bool {
        skipSeparators()
        guard i < chars.count else { return false }
        let c = chars[i]
        return c.isNumber || c == "-" || c == "+" || c == "."
    }

    mutating func number() -> Double {
        skipSeparators()
        var str = ""
        if i < chars.count, chars[i] == "-" || chars[i] == "+" {
            str.append(chars[i])
            i += 1
        }
        var seenDot = false
        var seenExp = false
        while i < chars.count {
            let c = chars[i]
            if c.isNumber {
                str.append(c)
                i += 1
            } else if c == "." && !seenDot && !seenExp {
                seenDot = true
                str.append(c)
                i += 1
            } else if (c == "e" || c == "E") && !seenExp {
                seenExp = true
                str.append(c)
                i += 1
                if i < chars.count, chars[i] == "-" || chars[i] == "+" {
                    str.append(chars[i])
                    i += 1
                }
            } else {
                break
            }
        }
        return Double(str) ?? 0
    }
}
