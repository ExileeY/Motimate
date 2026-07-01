import XCTest
@testable import Motimate

final class GoalStorageTests: XCTestCase {
    private let normalize: (Int) -> Int = { normalizeGoal(Double($0)) }

    func testPassesThroughAnInRangeValueUnchanged() {
        let subject = (GOAL_MIN + GOAL_MAX) / 2
        XCTAssertEqual(normalize(subject), subject)
    }

    func testClampsBelowTheMinimumUpToGoalMin() {
        for value in [-1_000, 0, GOAL_MIN - 500] {
            XCTAssertEqual(normalize(value), GOAL_MIN)
        }
    }

    func testClampsAboveTheMaximumDownToGoalMax() {
        XCTAssertEqual(normalize(GOAL_MAX + 5_000), GOAL_MAX)
    }

    func testKeepsTheBoundsThemselves() {
        XCTAssertEqual(normalize(GOAL_MIN), GOAL_MIN)
        XCTAssertEqual(normalize(GOAL_MAX), GOAL_MAX)
    }

    func testRoundsFractionalValues() {
        XCTAssertEqual(normalizeGoal(8_000.4), 8_000)
        XCTAssertEqual(normalizeGoal(8_000.6), 8_001)
    }

    func testFallsBackToGoalDefaultForNonFiniteValues() {
        XCTAssertEqual(normalizeGoal(.nan), GOAL_DEFAULT)
        XCTAssertEqual(normalizeGoal(.infinity), GOAL_DEFAULT)
        XCTAssertEqual(normalizeGoal(-.infinity), GOAL_DEFAULT)
    }
}
