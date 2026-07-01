import SwiftUI

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

struct PetDefinition {
    let name: String
    let body: (Mood, CGFloat?) -> AnyView
    let pickMessages: () -> [Mood: MessageSet]
}

let PETS: [PetId: PetDefinition] = [
    .mochi: PetDefinition(
        name: "Mochi",
        body: { (mood, size) in AnyView(
            MochiBody(
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(mochiMessages) }
    ),
    .bulbashik: PetDefinition(
        name: "Bulbashik",
        body: { (mood, size) in AnyView(
            BulbashikBody(
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(bulbashikMessages) }
    ),
    .dog: PetDefinition(
        name: "Dog",
        body: { mood, size in AnyView(
            DogBody(
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(dogMessages) }
    ),
    .octopus: PetDefinition(
        name: "Octopus",
        body: { mood, size in AnyView(
            OctopusBody(
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(octopusMessages) }
    ),
    .arutic: PetDefinition(
        name: "Arutic",
        body: { mood, size in AnyView(
            PlaceholderPetBody(
                name: "Arutic",
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(aruticMessages) }
    ),
    .khinklear: PetDefinition(
        name: "Khinklear",
        body: { mood, size in AnyView(
            PlaceholderPetBody(
                name: "Khinklear",
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(khinklearMessages) }
    ),
    .tomato: PetDefinition(
        name: "Tomato",
        body: { mood, size in AnyView(
            PlaceholderPetBody(
                name: "Tomato",
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(tomatoMessages) }
    ),
    .schnauzer: PetDefinition(
        name: "Schnauzer",
        body: { mood, size in AnyView(
            PlaceholderPetBody(
                name: "Schnauzer",
                mood: mood,
                size: size)
        )},
        pickMessages: { pickMessages(schnauzerMessages) }
    ),
]

let PET_ID_DEFAULT: PetId = .mochi
let PET_IDS = PetId.allCases

func petDefinition(_ id: PetId) -> PetDefinition {
    PETS[id] ?? PETS[PET_ID_DEFAULT]!
}
