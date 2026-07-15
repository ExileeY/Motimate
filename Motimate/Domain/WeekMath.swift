import Foundation

enum WeekMath {
    private static var isoCalendar: Calendar {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.firstWeekday = 2 // Monday
        calendar.minimumDaysInFirstWeek = 4 // ISO 8601 calendars (European standard)
        return calendar
    }

    static func startOfWeek(for date: Date = Date()) -> Date {
        let calendar = isoCalendar
        return calendar.dateInterval(of: .weekOfYear, for: date)?.start
            ?? calendar.startOfDay(for: date)
    }

    static func weeksBetween(_ from: Date, _ to: Date) -> Int {
        isoCalendar.dateComponents(
            [.weekOfYear], from: startOfWeek(for: from), to: startOfWeek(for: to)
        ).weekOfYear ?? 0
    }
}
