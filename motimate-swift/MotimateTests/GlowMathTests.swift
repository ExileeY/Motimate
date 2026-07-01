import XCTest
@testable import Motimate

final class GlowMathTests: XCTestCase {
    func testLinearInterpolateReturnsMinAtProgressZero() {
        XCTAssertEqual(
            GlowMath.linearInterpolate(10, 20, 0),
            10
        )
    }

    func testLinearInterpolateReturnsMaxAtProgressOne() {
        XCTAssertEqual(
            GlowMath.linearInterpolate(10, 20, 1),
            20
        )
    }

    func testLinearInterpolateReturnsMidpoint() {
        XCTAssertEqual(
            GlowMath.linearInterpolate(10, 20, 0.5),
            15
        )
    }

    func testLinearInterpolateExtrapolatesPastRange() {
        XCTAssertEqual(
            GlowMath.linearInterpolate(0, 10, 2),
            20
        )
    }

    func testTriangleOpacityRampsUpDuringFadeIn() {
        let fadeIn: CGFloat = 0.3

        XCTAssertEqual(
            GlowMath.calcTriangleOpacity(
                progress: 0,
                fadeIn: fadeIn
            ),
            0
        )
        XCTAssertEqual(
            GlowMath.calcTriangleOpacity(
                progress: fadeIn / 2,
                fadeIn: fadeIn
            ),
            0.5,
            accuracy: 0.0001
        )
    }

    func testTriangleOpacityPeaksAtFadeInBoundary() {
        let fadeIn: CGFloat = 0.3

        XCTAssertEqual(
            GlowMath.calcTriangleOpacity(
                progress: fadeIn,
                fadeIn: fadeIn
            ),
            1,
            accuracy: 0.0001
        )
    }

    func testTriangleOpacityRampsDownByEnd() {
        let fadeIn: CGFloat = 0.3

        XCTAssertEqual(
            GlowMath.calcTriangleOpacity(
                progress: 1,
                fadeIn: fadeIn
            ),
            0,
            accuracy: 0.0001
        )
        XCTAssertEqual(
            GlowMath.calcTriangleOpacity(
                progress: fadeIn + (1 - fadeIn) / 2,
                fadeIn: fadeIn
            ),
            0.5,
            accuracy: 0.0001
        )
    }

    func testCalcTransformPreservesCenteredScale() {
        XCTAssertEqual(
            GlowMath.calcTransform(
                scale: 2,
                cx: 50,
                cy: 60
            ),
            GlowTransform(
                scale: 2,
                center: CGPoint(x: 50, y: 60),
                translation: .zero
            )
        )
    }

    func testCalcTransformIncludesOptionalTranslateOffset() {
        XCTAssertEqual(
            GlowMath.calcTransform(
                scale: 1,
                cx: 10,
                cy: 20,
                tx: 5,
                ty: -7
            ),
            GlowTransform(
                scale: 1,
                center: CGPoint(x: 10, y: 20),
                translation: CGSize(width: 5, height: -7)
            )
        )
    }
}
