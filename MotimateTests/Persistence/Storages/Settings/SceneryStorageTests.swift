import XCTest
@testable import Motimate

final class SceneryStorageTests: XCTestCase {
    func testPassesThroughEveryRegisteredSceneryIdUnchanged() {
        for id in SceneryStorage.ids {
            XCTAssertEqual(SceneryStorage.normalize(id), id)
        }
    }

    func testFallsBackToClassicForAnUnregisteredValue() {
        XCTAssertEqual(SceneryStorage.normalize(SceneryId(rawValue: "not-a-scenery")), .classic)
        XCTAssertEqual(SceneryStorage.normalize(nil), .classic)
        XCTAssertEqual(SceneryStorage.decode(nil), .classic)
        XCTAssertEqual(SceneryStorage.decode("garbage"), .classic)
    }

    func testRoundTrips() {
        for id in SceneryId.allCases {
            XCTAssertEqual(SceneryStorage.decode(SceneryStorage.encode(id)), id)
        }
    }
}
