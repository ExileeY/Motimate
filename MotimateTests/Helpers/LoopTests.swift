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

    // MARK: - .once (play-once, then hold)

    func testOnceStartsAtRest() {
        XCTAssertEqual(
            LoopTiming.progress(elapsedMs: 0, durationMs: 1_000, mode: .once),
            0,
            accuracy: 0.0001
        )
    }

    func testOnceReachesOneAtFullDuration() {
        XCTAssertEqual(
            LoopTiming.progress(elapsedMs: 1_000, durationMs: 1_000, mode: .once),
            1,
            accuracy: 0.0001
        )
    }

    func testOnceHoldsAtOnePastFullDuration() {
        // Unlike .rise, it must NOT wrap back to 0.
        XCTAssertEqual(
            LoopTiming.progress(elapsedMs: 5_000, durationMs: 1_000, mode: .once),
            1,
            accuracy: 0.0001
        )
    }

    func testOnceRespectsDelay() {
        XCTAssertEqual(
            LoopTiming.progress(elapsedMs: 199, durationMs: 1_000, delayMs: 200, mode: .once),
            0,
            accuracy: 0.0001
        )
    }

    /// The property `LoopClock.onFinished` relies on: at (and past) a full-duration
    /// boundary, only `.once` reads a held 1 — the repeating modes wrap back to 0.
    /// So a clock keyed on "progress reached 1" fires for `.once` alone.
    func testOnlyOnceReachesOneAtDurationBoundaries() {
        for cycles in 1...4 {
            let atBoundary = Double(cycles) * 1_000
            XCTAssertEqual(
                LoopTiming.progress(elapsedMs: atBoundary, durationMs: 1_000, mode: .once),
                1, accuracy: 0.0001, "once should hold at 1 past its end"
            )
            for mode in [LoopMode.pingPong, .rise] {
                XCTAssertEqual(
                    LoopTiming.progress(elapsedMs: atBoundary, durationMs: 1_000, mode: mode),
                    0, accuracy: 0.0001, "\(mode) should wrap to rest, not hold at 1"
                )
            }
        }
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
