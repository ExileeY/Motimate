import XCTest
@testable import Motimate

final class GameModeStorageTests: XCTestCase {
    private let normalize = normalizeGameMode

    func testPassesThroughBothValidGameModes() {
        XCTAssertEqual(normalize(.standard), .standard)
        XCTAssertEqual(normalize(.real), .real)
    }

    func testFallsBackToDefaultForAnInvalidValue() {
        XCTAssertEqual(normalize(GameMode(rawValue: "arcade")), GAME_MODE_DEFAULT)
        XCTAssertEqual(normalize(nil), GAME_MODE_DEFAULT)
    }
}
