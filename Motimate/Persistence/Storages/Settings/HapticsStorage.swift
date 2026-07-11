import Foundation

enum HapticsStorage {
    static let defaultValue = false

    static func decode(_ value: String?) -> Bool {
        guard let value else { return HapticsStorage.defaultValue }
        return value == "true"
    }

    static func encode(_ value: Bool) -> String {
        value ? "true" : "false"
    }

    static func normalize(_ value: Bool?) -> Bool {
        value ?? defaultValue
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<Bool> {
        PersistedStorage(
            key: "motimate.haptics",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
