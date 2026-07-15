import XCTest
@testable import Motimate

final class WeekMathTests: XCTestCase {
    private static func localNoon(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return Calendar.current.date(from: components)!
    }

    private func assertIsMonday(_ date: Date, file: StaticString = #filePath, line: UInt = #line) {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .current
        XCTAssertEqual(
            calendar.component(.weekday, from: date),
            2, // Monday
            "expected a Monday, got \(date)",
            file: file,
            line: line
        )
    }

    // MARK: - startOfWeek

    func testStartOfWeekIsAlwaysMonday() {
        let monday = WeekMath.startOfWeek(for: Self.localNoon(2026, 7, 13))
        assertIsMonday(monday)

        for day in 13...19 {
            XCTAssertEqual(
                WeekMath.startOfWeek(for: Self.localNoon(2026, 7, day)),
                monday,
                "day \(day) should map to the same Monday"
            )
        }
    }

    func testSundayAndMondayAreDifferentWeeks() {
        let prevWeekMonday = WeekMath.startOfWeek(for: Self.localNoon(2026, 7, 19))
        let currWeekMonday = WeekMath.startOfWeek(for: Self.localNoon(2026, 7, 20))

        XCTAssertNotEqual(prevWeekMonday, currWeekMonday)
        XCTAssertEqual(WeekMath.weeksBetween(prevWeekMonday, currWeekMonday), 1)
    }

    func testStartOfWeekIsLocalMidnight() {
        let monday = WeekMath.startOfWeek(for: Self.localNoon(2026, 7, 15))
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: monday)

        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
    }

    func testYearBoundaryWeekIsContiguous() {
        let dec29 = WeekMath.startOfWeek(for: Self.localNoon(2025, 12, 29))
        let jan1 = WeekMath.startOfWeek(for: Self.localNoon(2026, 1, 1))
        XCTAssertEqual(dec29, jan1, "29 Dec 2025 and 1 Jan 2026 are the same ISO week")

        let dec22 = WeekMath.startOfWeek(for: Self.localNoon(2025, 12, 22))
        XCTAssertEqual(WeekMath.weeksBetween(dec22, jan1), 1)
    }

    // MARK: - weeksBetween

    func testWeeksBetweenIsZeroWithinTheSameWeek() {
        XCTAssertEqual(
            WeekMath.weeksBetween(Self.localNoon(2026, 7, 13), Self.localNoon(2026, 7, 19)),
            0
        )
    }

    func testWeeksBetweenCountsWholeWeeks() {
        let origin = Self.localNoon(2026, 7, 13)
        XCTAssertEqual(WeekMath.weeksBetween(origin, Self.localNoon(2026, 7, 20)), 1)
        XCTAssertEqual(WeekMath.weeksBetween(origin, Self.localNoon(2026, 7, 27)), 2)
        XCTAssertEqual(WeekMath.weeksBetween(origin, Self.localNoon(2026, 8, 24)), 6)
    }

    func testWeeksBetweenIsNegativeGoingBackwards() {
        XCTAssertEqual(
            WeekMath.weeksBetween(Self.localNoon(2026, 7, 20), Self.localNoon(2026, 7, 13)),
            -1
        )
    }

    func testWeeksBetweenSpansDSTWithoutDrift() {
        let before = Self.localNoon(2026, 3, 2)
        let after = Self.localNoon(2026, 3, 9)

        XCTAssertEqual(WeekMath.weeksBetween(before, after), 1)
        assertIsMonday(WeekMath.startOfWeek(for: after))
    }
}
