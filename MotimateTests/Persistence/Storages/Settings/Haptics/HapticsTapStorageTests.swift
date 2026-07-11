import XCTest
@testable import Motimate

final class HapticsTapStorageTests: XCTestCase {
    private let normalize = HapticsTapStorage.normalize

    func testPassesThroughBothBooleanValues() {
        XCTAssertEqual(normalize(true), true)
        XCTAssertEqual(normalize(false), false)
    }

    func testFallsBackToDefaultForNil() {
        XCTAssertEqual(normalize(nil), HapticsTapStorage.defaultValue)
    }

    func testDefaultIsOff() {
        XCTAssertFalse(HapticsTapStorage.defaultValue)
    }
}
