import SwiftUI

struct OctopusEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let irisX: CGFloat
    let irisY: CGFloat

    private static let SCLERA = (
        w: CGFloat(32),
        h: CGFloat(36)
    )
    private static let IRIS = (
        w: CGFloat(15),
        h: CGFloat(17)
    )
    private static let CATCHLIGHT = (
        dx: CGFloat(3),
        dy: CGFloat(3),
        r: CGFloat(2.5)
    )

    var body: some View {
        let x = ox + dx
        let y = oy + dy
        let s = Self.SCLERA
        let i = Self.IRIS
        let c = Self.CATCHLIGHT

        ZStack {
            // Sclera
            Ellipse()
                .fill(Color(hex: "#FBF3EC"))
                .frame(width: s.w, height: s.h)
                .position(x: x + s.w / 2, y: y + s.h / 2)

            // Iris
            Ellipse()
                .fill(Color(hex: "#4A352A"))
                .frame(width: i.w, height: i.h)
                .position(x: x + irisX + i.w / 2, y: y + irisY + i.h / 2)

            // Catchlight
            Circle()
                .fill(Color.white)
                .frame(width: c.r * 2, height: c.r * 2)
                .position(x: x + irisX + c.dx + c.r, y: y + irisY + c.dy + c.r)
        }
    }
}
