import XCTest
@testable import Motimate

final class PetStorageTests: XCTestCase {
    func testPassesThroughEveryRegisteredPetIdUnchanged() {
        for id in PetStorage.ids {
            XCTAssertEqual(PetStorage.normalize(id), id)
        }
    }

    func testFallsBackToPetDefaultForAnUnregisteredValue() {
        XCTAssertEqual(PetStorage.normalize(PetId(rawValue: "not-a-pet")), PetStorage.defaultValue)
        XCTAssertEqual(PetStorage.normalize(nil), PetStorage.defaultValue)
    }
}
