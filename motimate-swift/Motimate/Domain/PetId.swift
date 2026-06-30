// TODO(Step 7): move PetId into the full registry (Domain/Pet.swift) alongside
// PetDefinition + PETS. This is a temporary stub so pet persistence can be built now.
// Mirrors `PetId` / `PET_IDS` / `DEFAULT_PET_ID` from `src/pet/registry.ts`.
enum PetId: String, CaseIterable {
    case mochi
    case bulbashik
    case dog
    case octopus
    case arutic
    case khinklear
    case tomato
    case schnauzer
}

let PET_ID_DEFAULT: PetId = .mochi
let PET_IDS = PetId.allCases
