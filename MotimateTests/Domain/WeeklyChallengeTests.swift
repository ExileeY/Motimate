import XCTest
@testable import Motimate

final class WeeklyChallengeTests: XCTestCase {
    private var order: [AccessoryId] { Accessory.rotationOrder }

    // MARK: - Selection

    func testFirstWeekIsTheFirstItemInRotationOrder() {
        XCTAssertEqual(
            WeeklyChallenge.select(weekIndex: 0, owned: []),
            order.first
        )
    }

    func testCyclesThroughTheWholePoolThenRepeats() {
        var seen: [AccessoryId] = []
        for index in 0..<order.count {
            seen.append(WeeklyChallenge.select(weekIndex: index, owned: [])!)
        }
        XCTAssertEqual(seen, order)
        XCTAssertEqual(
            WeeklyChallenge.select(weekIndex: order.count, owned: []),
            order.first
        )
    }

    func testNeverOffersAnOwnedItem() {
        for index in 0..<(order.count * 3) {
            let owned: Set<AccessoryId> = [.coolShades]
            let picked = WeeklyChallenge.select(weekIndex: index, owned: owned)

            XCTAssertNotEqual(picked, .coolShades, "week \(index) offered an owned item")
            XCTAssertNotNil(picked)
        }
    }

    func testAllOwnedYieldsNil() {
        XCTAssertNil(WeeklyChallenge.select(weekIndex: 0, owned: Set(AccessoryId.allCases)))
        XCTAssertNil(WeeklyChallenge.select(weekIndex: 99, owned: Set(AccessoryId.allCases)))
    }

    // MARK: - Robustness

    func testNegativeIndexWrapsInsteadOfCrashing() {
        for index in -12 ... -1 {
            XCTAssertNotNil(WeeklyChallenge.select(weekIndex: index, owned: []))
        }
        XCTAssertEqual(
            WeeklyChallenge.select(weekIndex: -order.count, owned: []),
            order.first
        )
    }
}
