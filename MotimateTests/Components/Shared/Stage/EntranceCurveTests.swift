import XCTest
import CoreGraphics
@testable import Motimate

final class EntranceCurveTests: XCTestCase {
    func testStartsHiddenSmallAndLow() {
        let subject = EntranceCurve.frame(at: 0)

        XCTAssertEqual(subject.opacity, 0, accuracy: 0.0001, "should start invisible")
        XCTAssertEqual(subject.scale, 0.7, accuracy: 0.0001, "should start small")
        XCTAssertEqual(subject.offsetY, 26, accuracy: 0.0001, "should start below rest")
    }

    func testEndsVisibleAtRest() {
        let subject = EntranceCurve.frame(at: 1)

        XCTAssertEqual(subject.opacity, 1, accuracy: 0.0001, "should end visible")
        XCTAssertEqual(subject.scale, 1, accuracy: 0.0001, "should end at rest scale")
        XCTAssertEqual(subject.offsetY, 0, accuracy: 0.0001, "should end centered")
    }

    func testSwellsPastRestScaleMidFlight() {
        let peakInput = 1 - sqrt(1 - 0.7) // easeOut⁻¹(0.7), the 1.05 keyframe
        XCTAssertEqual(
            EntranceCurve.frame(at: peakInput).scale,
            1.05,
            accuracy: 0.0001,
            "entrance should swell past rest scale to 1.05"
        )
    }

    func testDuration() {
        XCTAssertEqual(EntranceCurve.durationMs, 1_250)
    }
}
