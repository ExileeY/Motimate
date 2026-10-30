import XCTest
import SwiftUI
@testable import Motimate

final class FractionalPathTests: XCTestCase {
    private let rect = CGRect(x: 10, y: 20, width: 200, height: 100)

    func testPointMapsFractionsIntoTheRect() {
        XCTAssertEqual(FractionalPath.point(rect, 0, 0), CGPoint(x: 10, y: 20))
        XCTAssertEqual(FractionalPath.point(rect, 0.5, 0.25), CGPoint(x: 110, y: 45))
        XCTAssertEqual(FractionalPath.point(rect, 1, 1), CGPoint(x: 210, y: 120))
    }

    func testShiftedMovesOnlyY() {
        let shifted = FractionalPath.shifted([(0.2, 0.3), (0.8, 0.6)], dy: -0.1)
        XCTAssertEqual(shifted.map(\.0), [0.2, 0.8])
        XCTAssertEqual(shifted[0].1, 0.2, accuracy: 0.0001)
        XCTAssertEqual(shifted[1].1, 0.5, accuracy: 0.0001)
    }

    func testPolygonSpansItsPoints() {
        let path = FractionalPath.polygon(rect, [(0, 0), (1, 0), (1, 1), (0, 1)])
        XCTAssertEqual(path.boundingRect, rect)
    }
}
