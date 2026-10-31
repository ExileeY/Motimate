import XCTest
@testable import Motimate

final class SceneryLayoutTests: XCTestCase {
    func testNoGroundLineKeepsTheArtUnshifted() {
        XCTAssertEqual(SceneryLayout.make(groundY: nil), .unshifted)
        XCTAssertEqual(SceneryLayout.make(groundY: SceneryLayout.initialGroundY), .unshifted)
    }

    func testGroundFollowsFullyAndBackdropFollowsByHalf() {
        let layout = SceneryLayout.make(groundY: SceneryLayout.initialGroundY - 0.1)
        XCTAssertEqual(layout.shiftForGround, -0.1, accuracy: 0.0001)
        XCTAssertEqual(layout.shiftForBackdrop, -0.05, accuracy: 0.0001)
    }

    func testGroundLineIsClamped() {
        let high = SceneryLayout.make(groundY: 0)
        let low = SceneryLayout.make(groundY: 1)
        XCTAssertEqual(high.shiftForGround, SceneryLayout.minGroundY - SceneryLayout.initialGroundY, accuracy: 0.0001)
        XCTAssertEqual(low.shiftForGround, SceneryLayout.maxGroundY - SceneryLayout.initialGroundY, accuracy: 0.0001)
    }
}
