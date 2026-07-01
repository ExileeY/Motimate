import SwiftUI

struct SchnauzerEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat

    private static let EYE = (
        w: CGFloat(17),
        h: CGFloat(21)
    )

    var body: some View {
        let x = ox + dx
        let y = oy + dy

        ZStack {
            Ellipse()
                .fill(Color(hex: "#2D2823"))
                .frame(width: Self.EYE.w, height: Self.EYE.h)
                .position(
                    x: x + Self.EYE.w / 2,
                    y: y + Self.EYE.h / 2
                )

            Circle()
                .fill(Color.white)
                .frame(width: 6, height: 6)
                .position(x: x + 6, y: y + 6)
        }
    }
}
