import XCTest
import CoreGraphics
@testable import Motimate

/// Port of `src/hooks/__tests__/useResponsiveScale.test.ts`.
final class ResponsiveScaleTests: XCTestCase {
    private let baseHeight: CGFloat = 812
    private let minScale: CGFloat = 0.85
    private let maxScale: CGFloat = 1.15

    func testIsOneAtReferenceHeight() {
        XCTAssertEqual(computeScale(baseHeight), 1, accuracy: 0.0001)
    }

    func testScalesDownProportionallyForShorterScreens() {
        XCTAssertEqual(computeScale(baseHeight * 0.95), 0.95, accuracy: 0.0001)
    }

    func testClampsToMinOnVeryShortScreens() {
        XCTAssertEqual(computeScale(400), minScale)
    }

    func testClampsToMaxOnVeryTallScreens() {
        XCTAssertEqual(computeScale(2_000), maxScale)
    }
}
