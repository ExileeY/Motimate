import SwiftUI

struct TomatoFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat
    let scale: CGFloat

    private static let BROW = Color(hex: "#7A2A1C")
    private static let BROW_TIRED = Color(hex: "#6E2618")
    private static let NOSE = Color(hex: "#3A211A")
    private static let MUSTACHE = Color(hex: "#3A211A")
    private static let BODY_WIDTH: CGFloat = 152
    private static let BODY_CENTER: CGFloat = BODY_WIDTH / 2

    var body: some View {
        ZStack {
            shared
            face
        }
    }

    // MARK: - Shared

    private var shared: some View {
        let W = Self.BODY_WIDTH
        return ZStack {
            Ellipse()
                .fill(Self.NOSE)
                .frame(width: 12 * scale, height: 9 * scale)
                .position(
                    x: ox + Self.BODY_CENTER * scale,
                    y: oy + (90 + 9 / 2) * scale
                )

            mustacheHalf()
            mustacheHalf(flip: true)

            cheek(cx: 16 + 15, cy: 84 + 9)
            cheek(cx: W - 16 - 15, cy: 84 + 9)
        }
    }

    private func cheek(cx: CGFloat, cy: CGFloat) -> some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#FF7862", 0, 0.55),
                GStop("#FF7862", 0.7, 0),
            ], cx: 0.5, cy: 0.5, r: 0.5, side: 30 * scale))
            .frame(width: 30 * scale, height: 18 * scale)
            .position(
                x: ox + cx * scale,
                y: oy + cy * scale
            )
    }

    private func mustacheHalf(flip: Bool = false) -> some View {
        let mirror: CGFloat = flip ? -1 : 1
        let cx = ox + Self.BODY_CENTER * scale
        let top = oy + 98 * scale
        let d = "M \(cx) \(top)"
            + " C \(cx + mirror * -10 * scale) \(top - 1 * scale), \(cx + mirror * -22 * scale) \(top + 3 * scale), \(cx + mirror * -30 * scale) \(top + 6 * scale)"
            + " C \(cx + mirror * -36 * scale) \(top + 9 * scale), \(cx + mirror * -40 * scale) \(top + 6 * scale), \(cx + mirror * -38 * scale) \(top + 3 * scale)"
            + " C \(cx + mirror * -36 * scale) \(top + 1 * scale), \(cx + mirror * -33 * scale) \(top + 1 * scale), \(cx + mirror * -31 * scale) \(top + 4 * scale)"
            + " C \(cx + mirror * -26 * scale) \(top + 7 * scale), \(cx + mirror * -16 * scale) \(top + 6 * scale), \(cx + mirror * -8 * scale) \(top + 4 * scale)"
            + " C \(cx + mirror * -5 * scale) \(top + 3 * scale), \(cx + mirror * -2 * scale) \(top + 3 * scale), \(cx) \(top + 3 * scale) Z"
        return svgPath(d).fill(Self.MUSTACHE)
    }

    // MARK: - Per-mood

    @ViewBuilder
    private var face: some View {
        let W = Self.BODY_WIDTH
        switch mood {
        case .energetic:
            ZStack {
                brow(
                    x: 34,
                    y: 43,
                    w: 24,
                    h: 6,
                    deg: 9,
                    pivotX: 46,
                    pivotY: 46,
                    color: Self.BROW
                )
                brow(
                    x: W - 34 - 24,
                    y: 43,
                    w: 24,
                    h: 6,
                    deg: -9,
                    pivotX: W - 46,
                    pivotY: 46,
                    color: Self.BROW
                )

                TomatoEye(
                    ox: ox,
                    oy: oy,
                    dx: 36,
                    dy: 52,
                    irisInset: 6,
                    scale: scale
                )
                TomatoEye(
                    ox: ox,
                    oy: oy,
                    dx: W - 36 - 26,
                    dy: 52,
                    irisInset: 3,
                    scale: scale
                )

                energeticMouth
            }
        case .calm:
            ZStack {
                brow(
                    x: 34,
                    y: 46,
                    w: 23,
                    h: 5,
                    deg: 5,
                    pivotX: 45,
                    pivotY: 48,
                    color: Self.BROW
                )
                brow(
                    x: W - 34 - 23,
                    y: 46,
                    w: 23,
                    h: 5,
                    deg: -5,
                    pivotX: W - 45,
                    pivotY: 48,
                    color: Self.BROW
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 36 * scale,
                    dy: 66 * scale,
                    d: "q \(12 * scale) \(-11 * scale) \(24 * scale) 0",
                    color: Color(hex: "#432418")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W - 36 - 24) * scale,
                    dy: 66 * scale,
                    d: "q \(12 * scale) \(-11 * scale) \(24 * scale) 0",
                    color: Color(hex: "#432418")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: ((W - 24) / 2) * scale,
                    dy: 110 * scale,
                    d: "q \(12 * scale) \(9 * scale) \(24 * scale) 0",
                    color: Color(hex: "#7A2418")
                )
            }
        case .tired:
            ZStack {
                brow(
                    x: 33,
                    y: 52,
                    w: 24,
                    h: 6,
                    deg: -12,
                    pivotX: 45,
                    pivotY: 55,
                    color: Self.BROW_TIRED
                )
                brow(
                    x: W - 33 - 24,
                    y: 52,
                    w: 24,
                    h: 6,
                    deg: 12,
                    pivotX: W - 45,
                    pivotY: 55,
                    color: Self.BROW_TIRED
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 36 * scale,
                    dy: 66 * scale,
                    d: "q \(11.5 * scale) \(9 * scale) \(23 * scale) 0",
                    color: Color(hex: "#3A2018")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W - 36 - 23) * scale,
                    dy: 66 * scale,
                    d: "q \(11.5 * scale) \(9 * scale) \(23 * scale) 0",
                    color: Color(hex: "#3A2018")
                )

                underEyeShade(
                    x: 38,
                    y: 76,
                    deg: 6,
                    pivotX: 47,
                    pivotY: 78
                )
                underEyeShade(
                    x: W - 38 - 18,
                    y: 76,
                    deg: -6,
                    pivotX: W - 47,
                    pivotY: 78
                )

                roundedBoxPath(
                    ox + ((W - 13) / 2) * scale,
                    oy + 110 * scale,
                    13 * scale,
                    9 * scale,
                    [
                        (0, 0),
                        (0, 0),
                        (0.54, 1),
                        (0.54, 1),
                    ]
                )
                .fill(Color(red: 70 / 255, green: 25 / 255, blue: 18 / 255).opacity(0.7))
            }
        case .sad:
            ZStack {
                brow(
                    x: 34,
                    y: 48,
                    w: 24,
                    h: 6,
                    deg: 16,
                    pivotX: 46,
                    pivotY: 51,
                    color: Self.BROW_TIRED
                )
                brow(
                    x: W - 34 - 24,
                    y: 48,
                    w: 24,
                    h: 6,
                    deg: -16,
                    pivotX: W - 46,
                    pivotY: 51,
                    color: Self.BROW_TIRED
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 36 * scale,
                    dy: 62 * scale,
                    d: "q \(12 * scale) \(10 * scale) \(24 * scale) 0",
                    color: Color(hex: "#3A2018")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W - 36 - 24) * scale,
                    dy: 62 * scale,
                    d: "q \(12 * scale) \(10 * scale) \(24 * scale) 0",
                    color: Color(hex: "#3A2018")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: ((W - 24) / 2) * scale,
                    dy: 114 * scale,
                    d: "q \(12 * scale) \(-9 * scale) \(24 * scale) 0",
                    color: Color(hex: "#7A2418")
                )
            }
        }
    }

    // MARK: - Helpers

    private func brow(
        x: CGFloat,
        y: CGFloat,
        w: CGFloat,
        h: CGFloat,
        deg: Double,
        pivotX: CGFloat,
        pivotY: CGFloat,
        color: Color
    ) -> some View {
        let corner = h / 2
        let rect = roundedBoxPath(
            ox + x * scale,
            oy + y * scale,
            w * scale,
            h * scale,
            [
                (corner / w, corner / h),
                (corner / w, corner / h),
                (corner / w, corner / h),
                (corner / w, corner / h),
            ]
        )
        let pivot = CGPoint(
            x: ox + pivotX * scale,
            y: oy + pivotY * scale
        )
        return rotatedPath(rect, degrees: deg, about: pivot).fill(color)
    }

    private func underEyeShade(
        x: CGFloat,
        y: CGFloat,
        deg: Double,
        pivotX: CGFloat,
        pivotY: CGFloat
    ) -> some View {
        let path = roundedBoxPath(
            ox + x * scale,
            oy + y * scale,
            18 * scale,
            5 * scale,
            [
                (0, 0),
                (0, 0),
                (0.44, 1),
                (0.44, 1),
            ]
        )
        let pivot = CGPoint(
            x: ox + pivotX * scale,
            y: oy + pivotY * scale
        )
        return rotatedPath(path, degrees: deg, about: pivot)
            .fill(Color(red: 90 / 255, green: 30 / 255, blue: 20 / 255).opacity(0.3))
    }

    private var energeticMouth: some View {
        let W = Self.BODY_WIDTH
        let mouthW: CGFloat = 30
        let mouthH: CGFloat = 17
        let mouthL = ox + ((W - mouthW) / 2) * scale
        let mouthR = mouthL + mouthW * scale
        let mouthT = oy + 108 * scale
        let mouthB = mouthT + mouthH * scale
        let tongueW: CGFloat = 20
        let tongueL = ox + ((W - tongueW) / 2) * scale
        let mouth = mouthPath(
            left: mouthL,
            top: mouthT,
            width: mouthW * scale,
            height: mouthH * scale
        )
        let tongue = tonguePath(
            left: tongueL,
            width: tongueW * scale,
            bottom: mouthB
        )

        return ZStack {
            mouth.fill(Color(hex: "#7A2418"))

            ZStack {
                tongue.fill(Color(hex: "#F2887C"))
                Path { path in
                    path.move(to: CGPoint(x: mouthL, y: mouthT + 2 * scale))
                    path.addLine(to: CGPoint(x: mouthR, y: mouthT + 2 * scale))
                }
                .stroke(
                    Color(red: 40 / 255, green: 12 / 255, blue: 8 / 255).opacity(0.45),
                    style: StrokeStyle(lineWidth: 3 * scale, lineCap: .round)
                )
            }
            .mask(mouth.fill(Color.white))
        }
    }

    private func mouthPath(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> Path {
        let right = left + width
        let bottom = top + height
        let cr = 15 * scale
        let sy = top + height - cr
        return svgPath(
            "M \(left) \(top) L \(right) \(top) L \(right) \(sy)"
                + " A \(cr) \(cr) 0 0 1 \(right - cr) \(bottom)"
                + " L \(left + cr) \(bottom)"
                + " A \(cr) \(cr) 0 0 1 \(left) \(sy) Z"
        )
    }

    private func tonguePath(left: CGFloat, width: CGFloat, bottom: CGFloat) -> Path {
        let right = left + width
        let top = bottom - 9 * scale
        let r = 9 * scale
        return svgPath(
            "M \(left) \(bottom) L \(left) \(top + r)"
                + " A \(r) \(r) 0 0 1 \(left + r) \(top)"
                + " L \(right - r) \(top)"
                + " A \(r) \(r) 0 0 1 \(right) \(top + r)"
                + " L \(right) \(bottom) Z"
        )
    }

    private func rotatedPath(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }
}
