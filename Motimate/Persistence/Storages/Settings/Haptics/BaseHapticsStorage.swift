import Foundation

protocol HapticsStorageKind {
    static var key: String { get }
    static var defaultValue: Bool { get }
}

extension HapticsStorageKind {
    static func decode(_ value: String?) -> Bool {
        value.map { $0 == "true" } ?? defaultValue
    }

    static func encode(_ value: Bool) -> String {
        value ? "true" : "false"
    }

    static func normalize(_ value: Bool?) -> Bool {
        value ?? defaultValue
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<Bool> {
        PersistedStorage(
            key: key,
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
