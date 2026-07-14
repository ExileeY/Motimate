import SwiftUI

struct BulbEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let irisInset: CGFloat

    private static let SCLERA = (
        w: CGFloat(26),
        h: CGFloat(30)
    )
    private static let IRIS = (
        w: CGFloat(17),
        h: CGFloat(19)
    )

    var body: some View {
        let x = ox + dx
        let y = oy + dy
        let irisCx = x + irisInset + Self.IRIS.w / 2
        let irisCy = y + 7 + Self.IRIS.h / 2

        ZStack {
            Ellipse()
                .fill(Color(hex: "#FBF6EC"))
                .frame(width: Self.SCLERA.w, height: Self.SCLERA.h)
                .position(x: x + Self.SCLERA.w / 2, y: y + Self.SCLERA.h / 2)

            Ellipse()
                .fill(Color(hex: "#5A3A20"))
                .frame(width: Self.IRIS.w, height: Self.IRIS.h)
                .position(x: irisCx, y: irisCy)

            Circle()
                .fill(Color.white)
                .frame(width: 5, height: 5)
                .position(x: irisCx + 1.5, y: irisCy - 6)
        }
    }
}
