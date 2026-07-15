import XCTest
@testable import Motimate

final class AccessoryRegistryTests: XCTestCase {
    func testEveryAccessoryIdHasARegistryEntry() {
        for id in AccessoryId.allCases {
            XCTAssertNotNil(Accessory.all[id], "missing Accessory.all entry for \(id.rawValue)")
        }
    }

    func testAccessoryIdsMatchesAllCases() {
        XCTAssertEqual(Accessory.ids, AccessoryId.allCases)
    }

    func testEveryAccessoryNameIsNonEmpty() {
        for id in AccessoryId.allCases {
            XCTAssertFalse(Accessory.all[id]!.name.isEmpty)
        }
    }

    func testEveryAccessoryGoalIsPositive() {
        for id in AccessoryId.allCases {
            XCTAssertGreaterThan(Accessory.all[id]!.weeklyStepGoal, 0, "\(id.rawValue) goal")
        }
    }

    // MARK: - Rotation

    func testRotationOrderIsTotalAndFreeOfDuplicates() {
        XCTAssertEqual(Set(Accessory.rotationOrder), Set(AccessoryId.allCases))
        XCTAssertEqual(Accessory.rotationOrder.count, AccessoryId.allCases.count)
    }

    // MARK: - Draw order

    /// A slot missing from `zOrder` makes its equipped accessory silently
    /// disappear from every pet, since `equippedList` drives it via compactMap.
    func testSlotZOrderIsTotalAndFreeOfDuplicates() {
        XCTAssertEqual(Set(AccessorySlot.zOrder), Set(AccessorySlot.allCases))
        XCTAssertEqual(AccessorySlot.zOrder.count, AccessorySlot.allCases.count)
    }
}
