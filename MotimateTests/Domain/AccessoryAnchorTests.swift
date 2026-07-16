import XCTest
@testable import Motimate

final class AccessoryAnchorTests: XCTestCase {
    func testEveryAccessoryHasAnAnchorForEveryPet() {
        for accessory in AccessoryId.allCases {
            for pet in PetId.allCases {
                XCTAssertNotNil(
                    ACCESSORY_ANCHORS[accessory]?[pet],
                    "missing anchor for \(accessory.rawValue) on \(pet.rawValue)"
                )
            }
        }
    }

    func testEveryAnchorScaleIsPositive() {
        for accessory in AccessoryId.allCases {
            for pet in PetId.allCases {
                let anchor = accessoryAnchor(accessory, pet)
                XCTAssertGreaterThan(anchor.scale, 0, "\(accessory.rawValue)/\(pet.rawValue)")
            }
        }
    }

    func testLookupReturnsTableEntryNotIdentity() {
        let mochi = accessoryAnchor(.coolShades, .mochi)
        XCTAssertEqual(mochi, ACCESSORY_ANCHORS[.coolShades]?[.mochi])
    }
}
