import XCTest
@testable import Motimate

final class PetStorageTests: XCTestCase {
    func testPassesThroughEveryRegisteredPetIdUnchanged() {
        for id in PET_IDS {
            XCTAssertEqual(normalizePet(id), id)
        }
    }

    func testFallsBackToPetDefaultForAnUnregisteredValue() {
        XCTAssertEqual(normalizePet(PetId(rawValue: "not-a-pet")), PET_DEFAULT)
        XCTAssertEqual(normalizePet(nil), PET_DEFAULT)
    }
}
