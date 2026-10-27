import SwiftUI

/// A home-screen backdrop.
enum SceneryId: String, CaseIterable {
    case classic
    case meadow

    var requiresDisablingAutoNight: Bool { self != .classic }
}

struct SceneryDefinition {
    let name: String
    let backdrop: (Mood) -> AnyView
}

let SCENERIES: [SceneryId: SceneryDefinition] = [
    .classic: SceneryDefinition(
        name: "Classic",
        backdrop: { mood in AnyView(ClassicScene(mood: mood)) }
    ),
    .meadow: SceneryDefinition(
        name: "Meadow",
        backdrop: { mood in AnyView(MeadowScene(mood: mood)) }
    ),
]

let SCENERY_ID_DEFAULT: SceneryId = .classic
let SCENERY_IDS = SceneryId.allCases

func sceneryDefinition(_ id: SceneryId) -> SceneryDefinition {
    SCENERIES[id] ?? SCENERIES[SCENERY_ID_DEFAULT]!
}
