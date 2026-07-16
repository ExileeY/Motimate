import Foundation

enum WeekItemStorage {
    static func decode(_ value: String?) -> AccessoryId? {
        value.flatMap { AccessoryId(rawValue: $0) }
    }

    static func encode(_ value: AccessoryId?) -> String {
        value?.rawValue ?? ""
    }

    static func normalize(_ value: AccessoryId?) -> AccessoryId? {
        value
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<AccessoryId?> {
        PersistedStorage(
            key: "motimate.week.item",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: nil,
            defaults: defaults
        )
    }
}
