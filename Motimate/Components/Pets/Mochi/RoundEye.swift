import SwiftUI

struct RoundEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    var color: Color = Color(hex: "#4A352A")

    var body: some View {
        ZStack {
            Ellipse()
                .fill(color)
                .frame(width: 16, height: 20)
                .position(x: ox + dx, y: oy + dy)

            Circle()
                .fill(Color.white)
                .frame(width: 6, height: 6)
                .position(x: ox + dx - 2, y: oy + dy - 4)
        }
    }
}
