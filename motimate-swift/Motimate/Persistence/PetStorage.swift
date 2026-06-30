import Foundation

/// Port of `src/settings/pet/storage.ts`. `PetId` / `PET_IDS` / `PET_ID_DEFAULT` are
/// the temporary stub in `Domain/PetId.swift` until the Step 7 registry supersedes them.
let PET_DEFAULT = PET_ID_DEFAULT

/// Mirrors the RN `normalize`: a value not in `PET_IDS` (here: an unregistered /
/// unparseable raw value, surfaced as `nil`) falls back to the default pet.
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
