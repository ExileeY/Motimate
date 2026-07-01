import SwiftUI

struct Arc: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let d: String
    let color: Color

    var body: some View {
        svgPath("M \(ox + dx) \(oy + dy) \(d)")
            .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
    }
}
