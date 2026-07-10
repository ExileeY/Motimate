import XCTest
@testable import Motimate

final class ConfettiMathTests: XCTestCase {
    func testDropsAPositivePieceCount() {
        XCTAssertGreaterThan(ConfettiMath.pieceCount, 0)
    }

    func testHasAPositiveDuration() {
        XCTAssertGreaterThan(ConfettiMath.durationMs, 0)
    }

    // MARK: - pieceProgress

    func testPieceProgressIsZeroBeforeItsWindow() {
        let value = ConfettiMath.pieceProgress(progress: 0.1, fallStart: 0.3, fallDuration: 0.5)
        XCTAssertEqual(value, 0)
    }

    func testPieceProgressRampsAcrossItsWindow() {
        let value = ConfettiMath.pieceProgress(progress: 0.55, fallStart: 0.3, fallDuration: 0.5)
        XCTAssertEqual(value, 0.5, accuracy: 0.0001)
    }

    func testPieceProgressClampsToOneAfterWindow() {
        let value = ConfettiMath.pieceProgress(progress: 1, fallStart: 0.3, fallDuration: 0.5)
        XCTAssertEqual(value, 1)
    }

    func testPieceProgressWithZeroSpanIsStep() {
        XCTAssertEqual(ConfettiMath.pieceProgress(progress: 0.2, fallStart: 0.3, fallDuration: 0), 0)
        XCTAssertEqual(ConfettiMath.pieceProgress(progress: 0.3, fallStart: 0.3, fallDuration: 0), 1)
    }

    // MARK: - placement

    func testStartsAboveTheAreaAndFullyOpaque() {
        let placement = ConfettiMath.placement(
            progress: 0,
            baseX: 100,
            areaHeight: 600,
            pieceSize: 12,
            swayAmp: 0,
            swayPhase: 0,
            swayCycles: 1
        )
        XCTAssertEqual(placement.position.y, -12, accuracy: 0.0001)
        XCTAssertEqual(placement.position.x, 100, accuracy: 0.0001)
        XCTAssertEqual(placement.opacity, 1, accuracy: 0.0001)
    }

    func testEndsPastTheBottomAndFullyFaded() {
        let placement = ConfettiMath.placement(
            progress: 1,
            baseX: 100,
            areaHeight: 600,
            pieceSize: 12,
            swayAmp: 0,
            swayPhase: 0,
            swayCycles: 1
        )
        XCTAssertEqual(placement.position.y, 612, accuracy: 0.0001)
        XCTAssertEqual(placement.opacity, 0, accuracy: 0.0001)
    }

    func testHoldsFullOpacityUntilFadeOutStart() {
        let placement = ConfettiMath.placement(
            progress: 0.7,
            baseX: 0,
            areaHeight: 600,
            pieceSize: 12,
            swayAmp: 0,
            swayPhase: 0,
            swayCycles: 1,
            fadeOutStart: 0.75
        )
        XCTAssertEqual(placement.opacity, 1, accuracy: 0.0001)
    }
}
