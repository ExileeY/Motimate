import XCTest
@testable import Motimate

final class HapticsAnimationStorageTests: XCTestCase {
    private let normalize = HapticsAnimationStorage.normalize

    func testPassesThroughBothBooleanValues() {
        XCTAssertEqual(normalize(true), true)
        XCTAssertEqual(normalize(false), false)
    }

    func testFallsBackToDefaultForNil() {
        XCTAssertEqual(normalize(nil), HapticsAnimationStorage.defaultValue)
    }

    func testDefaultIsOff() {
        XCTAssertFalse(HapticsAnimationStorage.defaultValue)
    }
}
