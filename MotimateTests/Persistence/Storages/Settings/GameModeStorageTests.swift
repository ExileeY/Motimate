import XCTest
@testable import Motimate

final class GameModeStorageTests: XCTestCase {
    private let normalize = GameModeStorage.normalize

    func testPassesThroughBothValidGameModes() {
        XCTAssertEqual(normalize(.standard), .standard)
        XCTAssertEqual(normalize(.real), .real)
    }

    func testFallsBackToDefaultForAnInvalidValue() {
        XCTAssertEqual(normalize(GameMode(rawValue: "arcade")), GameModeStorage.defaultValue)
        XCTAssertEqual(normalize(nil), GameModeStorage.defaultValue)
    }
}
