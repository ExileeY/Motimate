import XCTest
@testable import Motimate

final class GroundLineTests: XCTestCase {
    private let frame = CGRect(x: 0, y: -40, width: 390, height: 900)

    func testNoGroundLineHasNoFraction() {
        XCTAssertNil(GroundLine.fraction(nil, in: frame))
    }

    func testEmptyFrameHasNoFraction() {
        XCTAssertNil(GroundLine.fraction(100, in: CGRect(x: 0, y: 0, width: 390, height: 0)))
    }

    func testFractionIsMeasuredFromTheFrameTop() {
        XCTAssertEqual(GroundLine.fraction(frame.minY, in: frame)!, 0, accuracy: 0.0001)
        XCTAssertEqual(GroundLine.fraction(frame.midY, in: frame)!, 0.5, accuracy: 0.0001)
        XCTAssertEqual(GroundLine.fraction(frame.maxY, in: frame)!, 1, accuracy: 0.0001)
    }
}
