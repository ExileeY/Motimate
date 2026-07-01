import XCTest
@testable import Motimate

/// Port of `src/pet/__tests__/mood.test.ts`.
final class MoodTests: XCTestCase {
    private let goal = 10_000
    private var energeticMax: Double { Double(goal) * MOOD_MAX_RATIO[.energetic]! }
    private var calmMax: Double { Double(goal) * MOOD_MAX_RATIO[.calm]! }

    // MARK: - toMood: step thresholds (STANDARD mode)

    private func moodFor(_ steps: Int) -> Mood {
        StepsConvertor.toMood(steps: steps, goal: goal, mode: .standard, hour: 9)
    }

    func testEnergeticAtZeroSteps() {
        XCTAssertEqual(moodFor(0), .energetic)
    }

    func testEnergeticJustBelowEnergeticCap() {
        XCTAssertEqual(moodFor(Int(energeticMax) - 1), .energetic)
    }

    func testCalmExactlyAtEnergeticCap() {
        XCTAssertEqual(moodFor(Int(energeticMax)), .calm)
    }

    func testCalmJustBelowCalmCap() {
        XCTAssertEqual(moodFor(Int(calmMax) - 1), .calm)
    }

    func testTiredExactlyAtCalmCap() {
        XCTAssertEqual(moodFor(Int(calmMax)), .tired)
    }

    func testTiredWellPastGoal() {
        XCTAssertEqual(moodFor(goal * 5), .tired)
    }

    // MARK: - SAD overlay (REAL mode)

    func testTurnsEnergeticSadAtOrAfterMorningCutoff() {
        XCTAssertEqual(
            StepsConvertor.toMood(steps: 0, goal: goal, mode: .real, hour: MORNING_END_HOUR),
            .sad
        )
    }

    func testKeepsEnergeticBeforeMorningCutoff() {
        XCTAssertEqual(
            StepsConvertor.toMood(steps: 0, goal: goal, mode: .real, hour: MORNING_END_HOUR - 1),
            .energetic
        )
    }

    func testDoesNotApplySadToCalmOrTiredInAfternoon() {
        XCTAssertEqual(
            StepsConvertor.toMood(steps: Int(calmMax) - 1, goal: goal, mode: .real, hour: 18),
            .calm
        )
        XCTAssertEqual(
            StepsConvertor.toMood(steps: Int(calmMax), goal: goal, mode: .real, hour: 18),
            .tired
        )
    }

    func testNeverAppliesSadInStandardModeEvenEnergeticInAfternoon() {
        XCTAssertEqual(
            StepsConvertor.toMood(steps: 0, goal: goal, mode: .standard, hour: 18),
            .energetic
        )
    }

    // MARK: - toProgress

    func testProgressIsZeroAtZeroSteps() {
        XCTAssertEqual(StepsConvertor.toProgress(steps: 0, goal: goal), 0)
    }

    func testProgressIsRawRatioBelowGoal() {
        XCTAssertEqual(StepsConvertor.toProgress(steps: 2_500, goal: goal), 0.25, accuracy: 0.0001)
    }

    func testProgressIsOneExactlyAtGoal() {
        XCTAssertEqual(StepsConvertor.toProgress(steps: goal, goal: goal), 1)
    }

    func testProgressClampsToOneAboveGoal() {
        XCTAssertEqual(StepsConvertor.toProgress(steps: goal * 3, goal: goal), 1)
    }
}
