import XCTest
@testable import Motimate

final class GoalStorageTests: XCTestCase {
    private let normalize: (Int) -> Int = { GoalStorage.normalize($0) }

    func testPassesThroughAnInRangeValueUnchanged() {
        let subject = (GoalStorage.minValue + GoalStorage.maxValue) / 2
        XCTAssertEqual(normalize(subject), subject)
    }

    func testClampsBelowTheMinimumUpToGoalMin() {
        for value in [-1_000, 0, GoalStorage.minValue - 500] {
            XCTAssertEqual(normalize(value), GoalStorage.minValue)
        }
    }

    func testClampsAboveTheMaximumDownToGoalMax() {
        XCTAssertEqual(normalize(GoalStorage.maxValue + 5_000), GoalStorage.maxValue)
    }

    func testKeepsTheBoundsThemselves() {
        XCTAssertEqual(normalize(GoalStorage.minValue), GoalStorage.minValue)
        XCTAssertEqual(normalize(GoalStorage.maxValue), GoalStorage.maxValue)
    }

    func testRoundsFractionalValues() {
        XCTAssertEqual(GoalStorage.normalize(8_000.4), 8_000)
        XCTAssertEqual(GoalStorage.normalize(8_000.6), 8_001)
    }

    func testFallsBackToGoalDefaultForNonFiniteValues() {
        XCTAssertEqual(GoalStorage.normalize(.nan), GoalStorage.defaultValue)
        XCTAssertEqual(GoalStorage.normalize(.infinity), GoalStorage.defaultValue)
        XCTAssertEqual(GoalStorage.normalize(-.infinity), GoalStorage.defaultValue)
    }
}
