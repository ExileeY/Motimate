import XCTest
@testable import Motimate

final class AccessoryRegistryTests: XCTestCase {
    func testEveryAccessoryIdHasARegistryEntry() {
        for id in AccessoryId.allCases {
            XCTAssertNotNil(ACCESSORIES[id], "missing ACCESSORIES entry for \(id.rawValue)")
        }
    }

    func testAccessoryIdsMatchesAllCases() {
        XCTAssertEqual(ACCESSORY_IDS, AccessoryId.allCases)
    }

    func testEveryAccessoryNameIsNonEmpty() {
        for id in AccessoryId.allCases {
            XCTAssertFalse(ACCESSORIES[id]!.name.isEmpty)
        }
    }

    func testEveryAccessoryGoalIsPositive() {
        for id in AccessoryId.allCases {
            XCTAssertGreaterThan(ACCESSORIES[id]!.stepGoal, 0, "\(id.rawValue) goal")
        }
    }
}
