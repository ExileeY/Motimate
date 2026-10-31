import SwiftUI

/// Vertical shifts that put a scenery's ground under the pet's measured foot line.
/// The ground follows fully; distant features (Meadow's peaks, Beach's horizon) follow
/// by half so they keep their place on tall and short screens alike.
struct SceneryLayout: Equatable {
    static let initialGroundY: CGFloat = 0.625
    static let minGroundY: CGFloat = 0.42
    static let maxGroundY: CGFloat = 0.8
    static let backdropShiftRatio: CGFloat = 0.5

    static let unshifted = SceneryLayout(shift: 0)

    let shift: CGFloat

    var shiftForGround: CGFloat { shift }
    var shiftForBackdrop: CGFloat { shift * Self.backdropShiftRatio }

    static func make(groundY: CGFloat?) -> SceneryLayout {
        guard let groundY else { return .unshifted }

        let clamped = MathUtils.clamp(groundY, min: minGroundY, max: maxGroundY)
        return SceneryLayout(shift: clamped - initialGroundY)
    }
}
