import Foundation

enum SceneryStorage {
    static let defaultValue = SCENERY_ID_DEFAULT
    static let ids = SCENERY_IDS

    static func decode(_ value: String?) -> SceneryId {
        value.flatMap { SceneryId(rawValue: $0) } ?? defaultValue
    }

    static func encode(_ value: SceneryId) -> String {
        value.rawValue
    }

    static func normalize(_ value: SceneryId?) -> SceneryId {
        guard let value, ids.contains(value) else { return defaultValue }
        return value
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<SceneryId> {
        PersistedStorage(
            key: "motimate.scenery",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
