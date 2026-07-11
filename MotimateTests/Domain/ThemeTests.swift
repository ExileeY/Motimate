import XCTest
@testable import Motimate

final class ThemeTests: XCTestCase {
    // MARK: - Theme.resolve (pure)

    func testDayWhenLight() {
        XCTAssertEqual(Theme.resolve(autoNightEnabled: true, isDark: false), .day)
    }

    func testNightWhenEnabledAndDark() {
        XCTAssertEqual(Theme.resolve(autoNightEnabled: true, isDark: true), .night)
    }

    func testDayWhenDisabledEvenInDark() {
        XCTAssertEqual(Theme.resolve(autoNightEnabled: false, isDark: true), .day)
    }

    func testDayWhenDisabledAndLight() {
        XCTAssertEqual(Theme.resolve(autoNightEnabled: false, isDark: false), .day)
    }

    // MARK: - Token resolvers

    func testDayResolversIndexByMood() {
        let day = ThemeTokens.day
        for mood in Mood.allCases {
            XCTAssertEqual(day.statusDot(mood), day.statusDotTokens.day[mood]!)
            XCTAssertEqual(day.glow(mood).size, day.stageGlowTokens.day[mood]!.size)
            XCTAssertEqual(day.screenBackground(mood).colors, day.screenBgTokens.day[mood]!.colors)
        }
    }

    func testNightResolversCollapseToOneLookForEveryMood() {
        let night = ThemeTokens.night
        for mood in Mood.allCases {
            XCTAssertEqual(night.statusDot(mood), night.statusDotTokens.night)
            XCTAssertEqual(night.glow(mood).size, night.stageGlowTokens.night.size)
            XCTAssertEqual(night.screenBackground(mood).colors, night.screenBgTokens.night.colors)
        }
    }

    func testPaletteResolverPicksNightForNight() {
        XCTAssertEqual(ThemeTokens.for(.day).palette.text, Palette.day.text)
        XCTAssertEqual(ThemeTokens.for(.night).palette.text, Palette.night.text)
    }

    // MARK: - autoNight persistence

    func testAutoNightDefaultsOn() {
        let suite = "ThemeTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = SettingsStore(defaults: defaults)
        XCTAssertTrue(store.autoNightEnabled)
    }

    func testSetAutoNightPersistsAcrossReinstantiation() {
        let suite = "ThemeTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        SettingsStore(defaults: defaults).setAutoNight(false)

        let reloaded = SettingsStore(defaults: defaults)
        XCTAssertFalse(reloaded.autoNightEnabled)
    }
}
