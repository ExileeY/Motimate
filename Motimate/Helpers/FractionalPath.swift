import SwiftUI

/// Path helpers for shapes authored in fractions of their rect (x and y in 0...1),
/// so the same art fits any frame.
enum FractionalPath {
    static func point(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: rect.minX + x * rect.width, y: rect.minY + y * rect.height)
    }

    static func polygon(_ rect: CGRect, _ points: [(CGFloat, CGFloat)]) -> Path {
        var path = Path()
        path.addLines(points.map { point(rect, $0.0, $0.1) })
        path.closeSubpath()
        return path
    }

    static func shifted(_ points: [(CGFloat, CGFloat)], dy: CGFloat) -> [(CGFloat, CGFloat)] {
        points.map { ($0.0, $0.1 + dy) }
    }
}
