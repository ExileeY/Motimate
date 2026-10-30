import XCTest
@testable import Motimate

final class MeadowLayoutTests: XCTestCase {
    func testNoGroundLineKeepsTheArtUnshifted() {
        XCTAssertEqual(MeadowLayout.make(groundY: nil), .unshifted)
        XCTAssertEqual(MeadowLayout.make(groundY: MeadowLayout.initialGroundY), .unshifted)
    }

    func testHillsFollowTheGroundAndPeaksFollowByHalf() {
        let layout = MeadowLayout.make(groundY: MeadowLayout.initialGroundY - 0.1)
        XCTAssertEqual(layout.shiftForGround, -0.1, accuracy: 0.0001)
        XCTAssertEqual(layout.shiftForPeak, -0.05, accuracy: 0.0001)
    }

    func testGroundLineIsClamped() {
        let high = MeadowLayout.make(groundY: 0)
        let low = MeadowLayout.make(groundY: 1)
        XCTAssertEqual(high.shiftForGround, MeadowLayout.minGroundY - MeadowLayout.initialGroundY, accuracy: 0.0001)
        XCTAssertEqual(low.shiftForGround, MeadowLayout.maxGroundY - MeadowLayout.initialGroundY, accuracy: 0.0001)
    }
}
