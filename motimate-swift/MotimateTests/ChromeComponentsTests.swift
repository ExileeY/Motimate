import XCTest
import CoreGraphics
@testable import Motimate

final class ChromeComponentsTests: XCTestCase {
    private let message = MessageSet(
        headline: "Walk with me?",
        subtitle: "A little motion helps.",
        meta: "quiet so far",
        footer: "Tiny steps still count."
    )

    func testTimeOfDayMorningBoundary() {
        XCTAssertEqual(timeOfDay(hour: 0), "Morning")
        XCTAssertEqual(timeOfDay(hour: 11), "Morning")
    }

    func testTimeOfDayAfternoonBoundary() {
        XCTAssertEqual(timeOfDay(hour: 12), "Afternoon")
        XCTAssertEqual(timeOfDay(hour: 17), "Afternoon")
    }

    func testTimeOfDayEveningBoundary() {
        XCTAssertEqual(timeOfDay(hour: 18), "Evening")
        XCTAssertEqual(timeOfDay(hour: 23), "Evening")
    }

    func testFormatClockDoesNotPadHourButPadsMinute() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let date = calendar.date(from: DateComponents(
            timeZone: calendar.timeZone,
            year: 2026,
            month: 7,
            day: 1,
            hour: 7,
            minute: 5
        ))!

        XCTAssertEqual(formatClock(date, calendar: calendar), "7:05")
    }

    func testMovementMetaUsesLocalizedStepCountWhenLive() {
        XCTAssertEqual(
            movementMeta(
                message: message,
                steps: 1_234,
                hasLiveSteps: true,
                locale: Locale(identifier: "en_US")
            ),
            "1,234 steps"
        )
    }

    func testMovementMetaUsesMessageMetaWithoutLiveSteps() {
        XCTAssertEqual(
            movementMeta(
                message: message,
                steps: 1_234,
                hasLiveSteps: false,
                locale: Locale(identifier: "en_US")
            ),
            "quiet so far"
        )
    }

    func testProgressFillFractionClampsBelowZero() {
        XCTAssertEqual(progressFillFraction(-0.2), 0)
    }

    func testProgressFillFractionClampsAboveOne() {
        XCTAssertEqual(progressFillFraction(1.5), 1)
    }

    func testProgressFillFractionRoundsToWholePercent() {
        XCTAssertEqual(progressFillFraction(0.424), 0.42, accuracy: 0.0001)
        XCTAssertEqual(progressFillFraction(0.425), 0.43, accuracy: 0.0001)
    }
}
