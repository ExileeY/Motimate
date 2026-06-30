import Foundation

let PET_DEFAULT = PET_ID_DEFAULT

func normalizePet(_ value: PetId?) -> PetId {
    guard let value, PET_IDS.contains(value) else { return PET_DEFAULT }
    return value
}

func makePetStorage(defaults: UserDefaults = .standard) -> PersistedStorage<PetId> {
    PersistedStorage(
        key: "motimate.pet",
        decode: { stored in stored.flatMap { PetId(rawValue: $0) } ?? PET_DEFAULT },
        encode: { $0.rawValue },
        normalize: { normalizePet($0) },
        fallback: PET_DEFAULT,
        defaults: defaults
    )
}
