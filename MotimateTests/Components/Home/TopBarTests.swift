import XCTest
@testable import Motimate

final class TopBarTests: XCTestCase {
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
}
