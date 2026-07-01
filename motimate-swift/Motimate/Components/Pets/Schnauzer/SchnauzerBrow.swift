import SwiftUI

struct SchnauzerBrow: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let w: CGFloat
    let h: CGFloat
    let rotate: Double

    var body: some View {
        let x = ox + dx
        let y = oy + dy
        let cx = x + w / 2
        let cy = y + h / 2

        rotatedPath(
            roundedBoxPath(x, y, w, h, [
                (0.62, 0.62),
                (0.62, 0.62),
                (0.5, 0.5),
                (0.5, 0.5),
            ]),
            degrees: rotate,
            about: CGPoint(x: cx, y: cy)
        )
        .fill(radialGradient([
            GStop("#E4DFD6", 0),
            GStop("#C7C2B8", 1),
        ], cx: 0.5, cy: 0.25, r: 0.7, side: w))
    }

    private func rotatedPath(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }
}
