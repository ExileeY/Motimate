import XCTest
@testable import Motimate

final class HapticsStorageTests: XCTestCase {
    private let normalize = HapticsStorage.normalize

    func testPassesThroughBothBooleanValues() {
        XCTAssertEqual(normalize(true), true)
        XCTAssertEqual(normalize(false), false)
    }

    func testFallsBackToDefaultForNil() {
        XCTAssertEqual(normalize(nil), HapticsStorage.defaultValue)
    }

    func testDefaultIsOff() {
        XCTAssertFalse(HapticsStorage.defaultValue)
    }
}
