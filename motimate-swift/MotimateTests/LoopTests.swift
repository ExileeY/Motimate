import XCTest
@testable import Motimate

/// Port coverage for `src/components/pet/hooks/useLoop.ts`.
final class LoopTests: XCTestCase {
    func testInactiveLoopHoldsAtRest() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 500,
                durationMs: 1_000,
                mode: .pingPong,
                active: false
            ),
            0
        )
    }

    func testLoopHoldsAtRestBeforeDelayCompletes() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 199,
                durationMs: 1_000,
                delayMs: 200,
                mode: .rise
            ),
            0
        )
    }

    func testDelayOnlyShiftsInitialCycleStart() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 700,
                durationMs: 1_000,
                delayMs: 200,
                mode: .rise
            ),
            0.5,
            accuracy: 0.0001
        )
    }

    func testPingPongStartsAtRest() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 0,
                durationMs: 1_000,
                mode: .pingPong
            ),
            0
        )
    }

    func testPingPongPeaksHalfwayThroughFullDuration() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 500,
                durationMs: 1_000,
                mode: .pingPong
            ),
            1,
            accuracy: 0.0001
        )
    }

    func testPingPongReturnsToRestAfterFullDuration() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 1_000,
                durationMs: 1_000,
                mode: .pingPong
            ),
            0,
            accuracy: 0.0001
        )
    }

    func testRiseRepeatsAfterFullDuration() {
        XCTAssertEqual(
            LoopTiming.progress(
                elapsedMs: 1_000,
                durationMs: 1_000,
                mode: .rise
            ),
            0,
            accuracy: 0.0001
        )
    }

    func testProgressIsClampedAcrossModes() {
        let samples = [
            LoopTiming.progress(elapsedMs: 250, durationMs: 1_000, mode: .rise),
            LoopTiming.progress(elapsedMs: 500, durationMs: 1_000, mode: .rise),
            LoopTiming.progress(elapsedMs: 750, durationMs: 1_000, mode: .rise),
            LoopTiming.progress(elapsedMs: 250, durationMs: 1_000, mode: .pingPong),
            LoopTiming.progress(elapsedMs: 500, durationMs: 1_000, mode: .pingPong),
            LoopTiming.progress(elapsedMs: 750, durationMs: 1_000, mode: .pingPong),
        ]

        samples.forEach { progress in
            XCTAssertGreaterThanOrEqual(progress, 0)
            XCTAssertLessThanOrEqual(progress, 1)
        }
    }
}
