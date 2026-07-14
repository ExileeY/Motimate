import SwiftUI

enum AccessoryId: String, CaseIterable {
    case coolShades
}

enum AccessorySlot: String, CaseIterable {
    case eyes
}

struct AccessoryDefinition {
    let name: String
    let stepGoal: Int
    let slot: AccessorySlot
    let view: (Mood, CGFloat, CGFloat) -> AnyView
}

enum Accessory {
    static let all: [AccessoryId: AccessoryDefinition] = [
        .coolShades: AccessoryDefinition(
            name: "Cool Shades",
            stepGoal: 8_000,
            slot: .eyes,
            view: { mood, size, spread in AnyView(
                Accessories.CoolShades(
                    mood: mood,
                    size: size,
                    spread: spread)
            )}
        ),
    ]

    static let ids = AccessoryId.allCases

    static func define(_ id: AccessoryId) -> AccessoryDefinition {
        all[id]!
    }
}
