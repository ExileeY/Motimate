import XCTest
import SwiftUI
@testable import Motimate

final class BeachSceneTests: XCTestCase {
    private let rect = CGRect(x: 0, y: 0, width: 390, height: 844)
    private let groundLines = [
        SceneryLayout.minGroundY,
        SceneryLayout.initialGroundY,
        SceneryLayout.maxGroundY,
    ]

    func testThePetsFeetAreAlwaysOnTheSand() {
        for groundY in groundLines {
            let layout = SceneryLayout.make(groundY: groundY)
            let feet = CGPoint(x: rect.midX, y: groundY * rect.height)
            let sand = BeachGeometry.drySand(shift: layout.shiftForGround).path(in: rect)
            XCTAssertTrue(sand.contains(feet), "feet off the sand at groundY \(groundY)")
        }
    }

    func testTheSeaStaysVisibleAboveTheSand() {
        for groundY in groundLines {
            let layout = SceneryLayout.make(groundY: groundY)
            let horizon = BeachGeometry.horizonY + layout.shiftForBackdrop
            let shoreline = BeachGeometry.shorelineY + layout.shiftForGround
            XCTAssertLessThan(horizon, shoreline, "no sea at groundY \(groundY)")

            let sand = BeachGeometry.drySand(shift: layout.shiftForGround).path(in: rect)
            let sea = CGPoint(x: rect.midX, y: (horizon + 0.01) * rect.height)
            XCTAssertFalse(sand.contains(sea), "sand covers the horizon at groundY \(groundY)")
        }
    }
}
