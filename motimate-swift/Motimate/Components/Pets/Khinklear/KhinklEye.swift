import SwiftUI

struct KhinklEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let scale: CGFloat

    private static let EYE = (
        w: CGFloat(15),
        h: CGFloat(19)
    )
    private static let HIGHLIGHT = (
        inset: CGFloat(3),
        r: CGFloat(3)
    )

    var body: some View {
        let x = ox + dx * scale
        let y = oy + dy * scale
        let e = Self.EYE
        let h = Self.HIGHLIGHT

        ZStack {
            // Iris
            Ellipse()
                .fill(Color(hex: "#4A352A"))
                .frame(width: e.w * scale, height: e.h * scale)
                .position(x: x + (e.w / 2) * scale, y: y + (e.h / 2) * scale)

            // Catchlight
            Circle()
                .fill(Color.white)
                .frame(width: h.r * 2 * scale, height: h.r * 2 * scale)
                .position(
                    x: x + (h.inset + h.r) * scale,
                    y: y + (h.inset + h.r) * scale
                )
        }
    }
}
