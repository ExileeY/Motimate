import XCTest
@testable import Motimate

final class WardrobeGroupingTests: XCTestCase {
    func testAccessoryIdsInSlotFiltersBySlot() {
        XCTAssertEqual(WardrobeGrouping.accessoryIds(in: .eyes), [.coolShades])
        XCTAssertEqual(WardrobeGrouping.accessoryIds(in: .pet), [.babyMochi])
    }

    func testPopulatedSlotsOnlyReturnsNonEmptySlots() {
        for slot in WardrobeGrouping.populatedSlots() {
            XCTAssertFalse(
                WardrobeGrouping.accessoryIds(in: slot).isEmpty,
                "populatedSlots returned an empty slot: \(slot.rawValue)"
            )
        }
    }

    func testPopulatedSlotsCoversEveryAccessoryExactlyOnce() {
        let flattened = WardrobeGrouping.populatedSlots().flatMap { WardrobeGrouping.accessoryIds(in: $0) }
        XCTAssertEqual(
            Set(flattened),
            Set(AccessoryId.allCases),
            "every accessory should appear in exactly one populated slot"
        )
        XCTAssertEqual(
            flattened.count,
            AccessoryId.allCases.count,
            "no accessory should be dropped or duplicated across slots"
        )
    }

    // MARK: - Ownership

    func testOwnedAccessoryIdsFiltersByOwnership() {
        let owned: Set<AccessoryId> = [.coolShades]

        XCTAssertEqual(
            WardrobeGrouping.ownedAccessoryIds(in: .eyes, owned: owned),
            [.coolShades]
        )
        XCTAssertEqual(
            WardrobeGrouping.ownedAccessoryIds(in: .pet, owned: owned),
            []
        )
    }

    func testOwnedAccessoryIdsWithNothingOwnedIsEmptyForEveryPopulatedSlot() {
        let owned = []

        for slot in WardrobeGrouping.populatedSlots() {
            XCTAssertEqual(
                WardrobeGrouping.ownedAccessoryIds(in: slot, owned: owned),
                [],
                "\(slot.rawValue) should list nothing when the user owns nothing"
            )
        }
    }

    func testOwnedAccessoryIdsWithEverythingOwnedMatchesAccessoryIds() {
        let owned = Set(AccessoryId.allCases)

        for slot in WardrobeGrouping.populatedSlots() {
            XCTAssertEqual(
                WardrobeGrouping.ownedAccessoryIds(in: slot, owned: owned),
                WardrobeGrouping.accessoryIds(in: slot),
                "\(slot.rawValue) should list its whole slot, in registry order"
            )
        }
    }

    func testOwnedCountStatusFormat() {
        XCTAssertEqual(WardrobeGrouping.ownedStatusString(owned: 2, total: 6), "2 / 6")
        XCTAssertEqual(WardrobeGrouping.ownedStatusString(owned: 0, total: 6), "0 / 6")
    }

    func testSlotDisplayTitles() {
        XCTAssertEqual(AccessorySlot.eyes.displayTitle, "Eyes")
        XCTAssertEqual(AccessorySlot.pet.displayTitle, "Pet")
    }
}
