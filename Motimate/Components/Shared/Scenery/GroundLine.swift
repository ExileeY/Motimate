import SwiftUI

/// The pet's foot line in `.global` coordinates, reported by Home's pet stage so
/// the backdrop can put its ground under the pet.
struct GroundLinePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue() ?? value
    }
}

enum GroundLine {
    /// The ground line as a fraction of `frame`'s height (both in `.global`
    /// coordinates)
    static func fraction(_ groundLine: CGFloat?, in frame: CGRect) -> CGFloat? {
        guard let groundLine, frame.height > 0 else { return nil }
        return (groundLine - frame.minY) / frame.height
    }
}

extension View {
    /// Reports a foot line `footOffset` below this view's center so the scenery can
    /// put its ground there. Reads the layout frame, which the bob/sway transforms
    /// don't move.
    func reportsGroundLine(footOffset: CGFloat) -> some View {
        background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: GroundLinePreferenceKey.self,
                    value: geo.frame(in: .global).midY + footOffset
                )
            }
        )
    }
}
