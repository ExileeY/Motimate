import SwiftUI

enum AccessoryId: String, CaseIterable {
    case coolShades
}

struct AccessoryDefinition {
    let name: String
    let stepGoal: Int
    let slot: AccessorySlot
    let art: (Mood, CGFloat, CGFloat) -> AnyView
}

let ACCESSORIES: [AccessoryId: AccessoryDefinition] = [
    .coolShades: AccessoryDefinition(
        name: "Cool Shades",
        stepGoal: 8_000,
        slot: .eyes,
        art: { mood, size, spread in AnyView(
            CoolShadesArt(
                mood: mood,
                size: size,
                spread: spread)
        )}
    ),
]

let ACCESSORY_IDS = AccessoryId.allCases

func accessoryDefinition(_ id: AccessoryId) -> AccessoryDefinition {
    ACCESSORIES[id]!
}
