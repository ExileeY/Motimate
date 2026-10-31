import XCTest
@testable import Motimate

final class MeadowTokensTests: XCTestCase {
    func testEveryMoodHasASpec() {
        for mood in Mood.allCases {
            XCTAssertNotNil(MeadowTokens.day[mood], "missing Meadow spec for \(mood.rawValue)")
        }
    }

    func testSkyColorsMatchLocations() {
        for mood in Mood.allCases {
            let sky = MeadowTokens.spec(mood).sky
            XCTAssertEqual(sky.colors.count, sky.locations.count)
        }
    }

    func testTiredSunSitsLowerAndDimmerThanEnergetic() {
        let energetic = MeadowTokens.spec(.energetic).sun
        let tired = MeadowTokens.spec(.tired).sun
        XCTAssertGreaterThan(tired.y, energetic.y)
        XCTAssertLessThan(tired.opacity, energetic.opacity)
    }

    func testSunDefaultsToSharedPositionAndSize() {
        for mood in Mood.allCases {
            let sun = MeadowTokens.spec(mood).sun
            XCTAssertEqual(sun.x, SunConfig.defaultX, "\(mood.rawValue) sun moved")
            XCTAssertEqual(sun.radius, SunConfig.defaultRadius, "\(mood.rawValue) sun resized")
        }
    }
}
