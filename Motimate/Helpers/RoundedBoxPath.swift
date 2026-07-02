import SwiftUI

// Standard constant for approximating a quarter-ellipse arc with a cubic Bézier:
// it places each control point this fraction of the way from the arc's endpoint
// toward the corner pivot. See https://spencermortensen.com/articles/bezier-circle/
private let K: CGFloat = 0.5523

private struct Pt {
    let x: CGFloat
    let y: CGFloat
}

/// Format a number the way JS `Number.toString()` does: trim trailing zeros,
/// no forced decimal point. Keeps the emitted string byte-identical to RN so
/// the ported inline snapshot passes verbatim.
private func fmt(_ n: CGFloat) -> String {
    let d = Double(n)
    if d == d.rounded() && abs(d) < 1e15 {
        return String(Int(d))
    }
    var s = String(format: "%.10f", d)
    while s.hasSuffix("0") { s.removeLast() }
    if s.hasSuffix(".") { s.removeLast() }
    return s
}

/// One corner as a cubic Bézier (`C ...`): a quarter-ellipse sweeping from
/// `from` to `to`, bulging toward the rectangle's `pivot` corner. Each control
/// point sits K of the way from an endpoint toward the pivot.
private func corner(_ from: Pt, _ pivot: Pt, _ to: Pt) -> String {
    let c1x = from.x + (pivot.x - from.x) * K
    let c1y = from.y + (pivot.y - from.y) * K
    let c2x = to.x + (pivot.x - to.x) * K
    let c2y = to.y + (pivot.y - to.y) * K
    return "C \(fmt(c1x)) \(fmt(c1y)) \(fmt(c2x)) \(fmt(c2y)) \(fmt(to.x)) \(fmt(to.y))"
}

/// A rounded-box outline whose four corners are independent elliptical arcs —
/// the SVG equivalent of CSS `border-radius` expressed as fractions of w/h.
///
/// `corners` is `[topLeft, topRight, bottomRight, bottomLeft]`, each
/// `(rxFrac, ryFrac)`. The perimeter is walked clockwise from the top-left
/// corner's left edge.
func roundedBoxString(
    _ x: CGFloat,
    _ y: CGFloat,
    _ w: CGFloat,
    _ h: CGFloat,
    _ corners: [(CGFloat, CGFloat)]
) -> String {
    let tl = corners[0], tr = corners[1], br = corners[2], bl = corners[3]
    let l = x
    let r = x + w
    let t = y
    let b = y + h

    let tlx = tl.0 * w, tly = tl.1 * h
    let trx = tr.0 * w, trh = tr.1 * h
    let brx = br.0 * w, brh = br.1 * h
    let blx = bl.0 * w, blh = bl.1 * h

    return [
        "M \(fmt(l)) \(fmt(t + tly))",
        corner(Pt(x: l, y: t + tly), Pt(x: l, y: t), Pt(x: l + tlx, y: t)),
        "L \(fmt(r - trx)) \(fmt(t))",
        corner(Pt(x: r - trx, y: t), Pt(x: r, y: t), Pt(x: r, y: t + trh)),
        "L \(fmt(r)) \(fmt(b - brh))",
        corner(Pt(x: r, y: b - brh), Pt(x: r, y: b), Pt(x: r - brx, y: b)),
        "L \(fmt(l + blx)) \(fmt(b))",
        corner(Pt(x: l + blx, y: b), Pt(x: l, y: b), Pt(x: l, y: b - blh)),
        "Z",
    ].joined(separator: " ")
}

/// The same geometry as `roundedBoxString`, replayed into a SwiftUI `Path` for
/// rendering. Built directly (not by parsing the string) so it stays exact.
func roundedBoxPath(
    _ x: CGFloat,
    _ y: CGFloat,
    _ w: CGFloat,
    _ h: CGFloat,
    _ corners: [(CGFloat, CGFloat)]
) -> Path {
    let tl = corners[0], tr = corners[1], br = corners[2], bl = corners[3]
    let l = x
    let r = x + w
    let t = y
    let b = y + h

    let tlx = tl.0 * w, tly = tl.1 * h
    let trx = tr.0 * w, trh = tr.1 * h
    let brx = br.0 * w, brh = br.1 * h
    let blx = bl.0 * w, blh = bl.1 * h

    func control(_ from: Pt, _ pivot: Pt) -> CGPoint {
        CGPoint(x: from.x + (pivot.x - from.x) * K, y: from.y + (pivot.y - from.y) * K)
    }

    var path = Path()

    path.move(to: CGPoint(x: l, y: t + tly))
    path.addCurve(
        to: CGPoint(x: l + tlx, y: t),
        control1: control(Pt(x: l, y: t + tly), Pt(x: l, y: t)),
        control2: control(Pt(x: l + tlx, y: t), Pt(x: l, y: t))
    )
    path.addLine(to: CGPoint(x: r - trx, y: t))
    path.addCurve(
        to: CGPoint(x: r, y: t + trh),
        control1: control(Pt(x: r - trx, y: t), Pt(x: r, y: t)),
        control2: control(Pt(x: r, y: t + trh), Pt(x: r, y: t))
    )
    path.addLine(to: CGPoint(x: r, y: b - brh))
    path.addCurve(
        to: CGPoint(x: r - brx, y: b),
        control1: control(Pt(x: r, y: b - brh), Pt(x: r, y: b)),
        control2: control(Pt(x: r - brx, y: b), Pt(x: r, y: b))
    )
    path.addLine(to: CGPoint(x: l + blx, y: b))
    path.addCurve(
        to: CGPoint(x: l, y: b - blh),
        control1: control(Pt(x: l + blx, y: b), Pt(x: l, y: b)),
        control2: control(Pt(x: l, y: b - blh), Pt(x: l, y: b))
    )
    path.closeSubpath()

    return path
}
