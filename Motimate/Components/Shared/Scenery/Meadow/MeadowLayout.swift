import SwiftUI

/// Vertical shifts that put the Meadow's grass under the pet's measured foot line.
/// The hills follow the ground fully; the mountain's peaks follow by half so the
/// range keeps its sky on tall and short screens alike.
struct MeadowLayout: Equatable {
    static let initialGroundY: CGFloat = 0.625
    static let minGroundY: CGFloat = 0.42
    static let maxGroundY: CGFloat = 0.8
    static let peakShiftRatio: CGFloat = 0.5

    static let unshifted = MeadowLayout(shift: 0)

    let shift: CGFloat

    var shiftForGround: CGFloat { shift } // hills + mountain base
    var shiftForPeak: CGFloat { shift * Self.peakShiftRatio } // mountain ridge + snow caps

    static func make(groundY: CGFloat?) -> MeadowLayout {
        guard let groundY else { return .unshifted }

        let clamped = MathUtils.clamp(groundY, min: minGroundY, max: maxGroundY)
        return MeadowLayout(shift: clamped - initialGroundY)
    }
}
