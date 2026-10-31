import SwiftUI

/// A home-screen backdrop.
enum SceneryId: String, CaseIterable {
    case classic
    case meadow
    case beach

    var requiresDisablingAutoNight: Bool { self != .classic }
}

/// Draws a scenery's backdrop.
struct SceneryBackdrop {
    private let render: (Mood, CGFloat?) -> AnyView

    init(_ render: @escaping (Mood, CGFloat?) -> AnyView) {
        self.render = render
    }

    func callAsFunction(_ mood: Mood, groundY: CGFloat? = nil) -> AnyView {
        render(mood, groundY)
    }
}

struct SceneryDefinition {
    let name: String
    let backdrop: SceneryBackdrop
    var groundShadow: Bool = false
}

let SCENERIES: [SceneryId: SceneryDefinition] = [
    .classic: SceneryDefinition(
        name: "Classic",
        backdrop: SceneryBackdrop { mood, _ in AnyView(ClassicScene(mood: mood)) }
    ),
    .meadow: SceneryDefinition(
        name: "Meadow",
        backdrop: SceneryBackdrop { mood, groundY in AnyView(MeadowScene(mood: mood, groundY: groundY)) },
        groundShadow: true
    ),
    .beach: SceneryDefinition(
        name: "Beach",
        backdrop: SceneryBackdrop { mood, groundY in AnyView(BeachScene(mood: mood, groundY: groundY)) },
        groundShadow: true
    ),
]

let SCENERY_ID_DEFAULT: SceneryId = .classic
let SCENERY_IDS = SceneryId.allCases

func sceneryDefinition(_ id: SceneryId) -> SceneryDefinition {
    SCENERIES[id] ?? SCENERIES[SCENERY_ID_DEFAULT]!
}
