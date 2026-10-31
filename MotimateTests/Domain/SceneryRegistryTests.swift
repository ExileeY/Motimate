import XCTest
@testable import Motimate

final class SceneryRegistryTests: XCTestCase {
    func testEverySceneryIdHasARegistryEntry() {
        for id in SceneryId.allCases {
            XCTAssertNotNil(SCENERIES[id], "missing SCENERIES entry for \(id.rawValue)")
        }
    }

    func testDefaultIsClassic() {
        XCTAssertEqual(SCENERY_ID_DEFAULT, .classic)
        XCTAssertEqual(SCENERY_IDS, SceneryId.allCases)
    }

    func testOnlyNonClassicSceneriesDisableAutoNight() {
        XCTAssertFalse(SceneryId.classic.requiresDisablingAutoNight)
        XCTAssertTrue(SceneryId.meadow.requiresDisablingAutoNight)
        XCTAssertTrue(SceneryId.beach.requiresDisablingAutoNight)
    }

    func testEveryNameIsNonEmpty() {
        for id in SceneryId.allCases {
            XCTAssertFalse(sceneryDefinition(id).name.isEmpty)
        }
    }

    func testOnlyNonClassicSceneriesDrawAGroundShadow() {
        XCTAssertFalse(sceneryDefinition(.classic).groundShadow)
        XCTAssertTrue(sceneryDefinition(.meadow).groundShadow)
        XCTAssertTrue(sceneryDefinition(.beach).groundShadow)
    }
}
