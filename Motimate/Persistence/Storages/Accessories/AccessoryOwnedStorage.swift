import Foundation

enum AccessoryOwnedStorage {
    static let defaultValue = false

    static func decode(_ value: String?) -> Bool {
        value.map { $0 == "true" } ?? defaultValue
    }

    static func encode(_ value: Bool) -> String {
        value ? "true" : "false"
    }

    static func normalize(_ value: Bool?) -> Bool {
        value ?? defaultValue
    }

    static func make(_ id: AccessoryId, defaults: UserDefaults = .standard) -> PersistedStorage<Bool> {
        PersistedStorage(
            key: "motimate.accessory.\(id.rawValue).owned",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
