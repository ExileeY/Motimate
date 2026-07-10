import Foundation

enum PetStorage {
    static let defaultValue = PET_ID_DEFAULT
    static let ids = PET_IDS

    static func decode(_ value: String?) -> PetId {
        value.flatMap { PetId(rawValue: $0) } ?? defaultValue
    }

    static func encode(_ value: PetId) -> String {
        value.rawValue
    }

    static func normalize(_ value: PetId?) -> PetId {
        guard let value, ids.contains(value) else { return defaultValue }
        return value
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<PetId> {
        PersistedStorage(
            key: "motimate.pet",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
