import XCTest
@testable import Motimate

final class MathUtilsTests: XCTestCase {
    // MARK: - clamp01

    func testClamp01FloorsBelowZero() {
        XCTAssertEqual(MathUtils.clamp01(-0.5), 0)
    }

    func testClamp01PassesValuesInRange() {
        XCTAssertEqual(MathUtils.clamp01(0.42), 0.42, accuracy: 0.0001)
    }

    func testClamp01CapsAboveOne() {
        XCTAssertEqual(MathUtils.clamp01(1.7), 1)
    }

    // MARK: - clamp(_:min:max:)

    func testClampFloorsToLowerBound() {
        XCTAssertEqual(MathUtils.clamp(-3, min: 0, max: 10), 0)
    }

    func testClampCapsToUpperBound() {
        XCTAssertEqual(MathUtils.clamp(42, min: 0, max: 10), 10)
    }

    func testClampPassesValuesInRange() {
        XCTAssertEqual(MathUtils.clamp(7, min: 0, max: 10), 7)
    }

    // MARK: - easeOut (quadratic)

    func testEaseOutIsZeroAtStart() {
        XCTAssertEqual(MathUtils.easeOut(0), 0, accuracy: 0.0001)
    }

    func testEaseOutIsOneAtEnd() {
        XCTAssertEqual(MathUtils.easeOut(1), 1, accuracy: 0.0001)
    }

    func testEaseOutDeceleratesPastHalfway() {
        XCTAssertEqual(MathUtils.easeOut(0.5), 0.75, accuracy: 0.0001)
    }

    func testEaseOutClampsOutOfRangeInput() {
        XCTAssertEqual(MathUtils.easeOut(-1), 0, accuracy: 0.0001)
        XCTAssertEqual(MathUtils.easeOut(2), 1, accuracy: 0.0001)
    }

    // MARK: - easeInOut (smoothstep)

    func testEaseInOutIsZeroAtStart() {
        XCTAssertEqual(MathUtils.easeInOut(0), 0, accuracy: 0.0001)
    }

    func testEaseInOutIsOneAtEnd() {
        XCTAssertEqual(MathUtils.easeInOut(1), 1, accuracy: 0.0001)
    }

    func testEaseInOutIsSymmetricAtMidpoint() {
        XCTAssertEqual(MathUtils.easeInOut(0.5), 0.5, accuracy: 0.0001)
    }

    func testEaseInOutClampsOutOfRangeInput() {
        XCTAssertEqual(MathUtils.easeInOut(-1), 0, accuracy: 0.0001)
        XCTAssertEqual(MathUtils.easeInOut(2), 1, accuracy: 0.0001)
    }

    // MARK: - linearInterpolate

    func testLinearInterpolateReturnsMinAtProgressZero() {
        XCTAssertEqual(MathUtils.linearInterpolate(10, 20, 0), 10)
    }

    func testLinearInterpolateReturnsMaxAtProgressOne() {
        XCTAssertEqual(MathUtils.linearInterpolate(10, 20, 1), 20)
    }

    func testLinearInterpolateReturnsMidpoint() {
        XCTAssertEqual(MathUtils.linearInterpolate(10, 20, 0.5), 15)
    }

    func testLinearInterpolateExtrapolatesPastRange() {
        XCTAssertEqual(MathUtils.linearInterpolate(0, 10, 2), 20)
    }
}
