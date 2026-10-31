import XCTest
@testable import Motimate

final class BeachTokensTests: XCTestCase {
    func testEveryMoodHasASpec() {
        for mood in Mood.allCases {
            XCTAssertNotNil(BeachTokens.day[mood], "missing Beach spec for \(mood.rawValue)")
        }
    }

    func testSkyColorsMatchLocations() {
        for mood in Mood.allCases {
            let sky = BeachTokens.spec(mood).sky
            XCTAssertEqual(sky.colors.count, sky.locations.count)
        }
    }

    func testTiredSunSitsLowerAndDimmerThanEnergetic() {
        let energetic = BeachTokens.spec(.energetic).sun
        let tired = BeachTokens.spec(.tired).sun
        XCTAssertGreaterThan(tired.y, energetic.y)
        XCTAssertLessThan(tired.opacity, energetic.opacity)
    }
}
