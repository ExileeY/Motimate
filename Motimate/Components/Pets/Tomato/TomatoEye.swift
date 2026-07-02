import SwiftUI

struct TomatoEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let irisInset: CGFloat
    let scale: CGFloat

    private static let SCLERA = (
        w: CGFloat(26),
        h: CGFloat(30)
    )
    private static let IRIS = (
        w: CGFloat(17),
        h: CGFloat(20)
    )

    var body: some View {
        let x = ox + dx * scale
        let y = oy + dy * scale
        let sclera = Self.SCLERA
        let iris = Self.IRIS
        let irisCx = x + (irisInset + iris.w / 2) * scale
        let irisCy = y + (6 + iris.h / 2) * scale

        ZStack {
            Ellipse()
                .fill(Color(hex: "#FBF3EC"))
                .frame(width: sclera.w * scale, height: sclera.h * scale)
                .position(
                    x: x + (sclera.w / 2) * scale,
                    y: y + (sclera.h / 2) * scale
                )

            Ellipse()
                .fill(radialGradient([
                    GStop("#6B3320", 0),
                    GStop("#38180E", 1),
                ], cx: 0.4, cy: 0.32, r: 0.7, side: iris.w * scale))
                .frame(width: iris.w * scale, height: iris.h * scale)
                .position(x: irisCx, y: irisCy)

            Circle()
                .fill(Color.white)
                .frame(width: 5 * scale, height: 5 * scale)
                .position(
                    x: x + (irisInset + 9 + 2.5) * scale,
                    y: y + (6 + 3 + 2.5) * scale
                )
        }
    }
}
