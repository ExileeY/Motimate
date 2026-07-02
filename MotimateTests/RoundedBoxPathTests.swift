import XCTest
import CoreGraphics
@testable import Motimate

/// Port of `src/components/pet/__tests__/svgPath.test.ts`.
final class RoundedBoxPathTests: XCTestCase {

    // MARK: - square figure

    private let squareCorners: [(CGFloat, CGFloat)] = [
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
    ]
    private var square: String { roundedBoxString(0, 0, 100, 100, squareCorners) }

    func testStartsWithMoveAndEndsClosed() {
        XCTAssertTrue(square.hasPrefix("M "))
        XCTAssertTrue(square.hasSuffix("Z"))
    }

    func testEmitsOneCubicBezierPerCorner() {
        let curves = square.components(separatedBy: "C ").count - 1
        XCTAssertEqual(curves, 4)
    }

    func testEmitsThreeStraightEdgesBetweenCorners() {
        let lines = square.components(separatedBy: "L ").count - 1
        XCTAssertEqual(lines, 3)
    }

    // MARK: - other figure

    func testProducesStablePathForKnownRoundedBox() {
        let corners: [(CGFloat, CGFloat)] = [
            (0.5, 0.5),
            (0.5, 0.5),
            (0.2, 0.2),
            (0.2, 0.2),
        ]
        let subject = roundedBoxString(10, 20, 80, 60, corners)
        XCTAssertEqual(
            subject,
            "M 10 50 C 10 33.431 27.908 20 50 20 L 50 20 C 72.092 20 90 33.431 90 50 L 90 68 C 90 74.6276 82.8368 80 74 80 L 26 80 C 17.1632 80 10 74.6276 10 68 Z"
        )
    }
}
