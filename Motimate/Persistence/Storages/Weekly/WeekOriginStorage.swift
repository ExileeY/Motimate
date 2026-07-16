import Foundation

/// The Monday of the week the app was first opened. The rotation index counts
/// weeks from here, so a new user's first week is always `rotationOrder[0]`.
enum WeekOriginStorage {
    static func decode(_ value: String?) -> Date? {
        value.flatMap(Double.init).map(Date.init(timeIntervalSince1970:))
    }

    static func encode(_ value: Date?) -> String {
        value.map { String($0.timeIntervalSince1970) } ?? ""
    }

    static func normalize(_ value: Date?) -> Date? {
        value.map { WeekMath.startOfWeek(for: $0) }
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<Date?> {
        PersistedStorage(
            key: "motimate.week.origin",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: nil,
            defaults: defaults
        )
    }
}
