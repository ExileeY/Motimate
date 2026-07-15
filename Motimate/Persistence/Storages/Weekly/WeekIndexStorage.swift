import Foundation

enum WeekIndexStorage {
    static func decode(_ value: String?) -> Int? {
        value.flatMap(Int.init)
    }

    static func encode(_ value: Int?) -> String {
        value.map(String.init) ?? ""
    }

    static func normalize(_ value: Int?) -> Int? {
        value
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<Int?> {
        PersistedStorage(
            key: "motimate.week.index",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: nil,
            defaults: defaults
        )
    }
}
