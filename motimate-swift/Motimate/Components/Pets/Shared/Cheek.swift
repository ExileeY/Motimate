import SwiftUI

struct Cheek: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    var color: Color = Color(hex: "#F2938b")
    let opacity: Double
    var rx: CGFloat = 11
    var ry: CGFloat = 7.5
    var blur: CGFloat = 0

    var body: some View {
        Ellipse()
            .fill(color)
            .frame(width: rx * 2, height: ry * 2)
            .position(x: ox + dx, y: oy + dy)
            .opacity(opacity)
            .blur(radius: blur)
    }
}
