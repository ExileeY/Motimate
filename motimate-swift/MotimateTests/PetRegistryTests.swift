import XCTest
@testable import Motimate

final class PetRegistryTests: XCTestCase {
    func testEveryPetIdHasARegistryEntry() {
        for id in PetId.allCases {
            XCTAssertNotNil(PETS[id], "missing PETS entry for \(id.rawValue)")
        }
    }

    func testRegistryHasAllEightPets() {
        XCTAssertEqual(PETS.count, 8)
        XCTAssertEqual(PetId.allCases.count, 8)
    }

    func testDefaultPetIsMochi() {
        XCTAssertEqual(PET_ID_DEFAULT, .mochi)
        XCTAssertNotNil(PETS[PET_ID_DEFAULT])
    }

    func testPetIdsMatchesAllCases() {
        XCTAssertEqual(PET_IDS, PetId.allCases)
    }

    func testEveryPetNameIsNonEmpty() {
        for id in PetId.allCases {
            XCTAssertFalse(PETS[id]!.name.isEmpty)
        }
    }

    func testPickMessagesCoversEveryMoodForEveryPet() {
        for id in PetId.allCases {
            let picked = PETS[id]!.pickMessages()
            for mood in Mood.allCases {
                XCTAssertNotNil(picked[mood], "\(id.rawValue) missing \(mood.rawValue) message")
            }
        }
    }

    /// Mood pools have the expected counts (10/10/10/3) and are non-empty.
    func testMessagePoolCountsPerPet() {
        let pools: [(String, [Mood: [MessageSet]])] = [
            ("mochi", mochiMessages),
            ("bulbashik", bulbashikMessages),
            ("dog", dogMessages),
            ("octopus", octopusMessages),
            ("arutic", aruticMessages),
            ("khinklear", khinklearMessages),
            ("tomato", tomatoMessages),
            ("schnauzer", schnauzerMessages),
        ]
        for (name, pool) in pools {
            XCTAssertEqual(pool[.energetic]?.count, 10, "\(name) energetic")
            XCTAssertEqual(pool[.calm]?.count, 10, "\(name) calm")
            XCTAssertEqual(pool[.tired]?.count, 10, "\(name) tired")
            XCTAssertEqual(pool[.sad]?.count, 3, "\(name) sad")
        }
    }

    func testPetDefinitionFallsBackToDefaultForLookup() {
        XCTAssertEqual(petDefinition(.tomato).name, "Tomato")
    }
}
