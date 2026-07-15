import SwiftUI

enum AccessoryId: String, CaseIterable {
    case coolShades
    case babyMochi
}

enum AccessorySlot: String, CaseIterable {
    case eyes
    case pet

    var displayTitle: String {
        switch self {
        case .eyes: return "Eyes"
        case .pet: return "Pet"
        }
    }

    /// Back-to-front draw order on the pet. Deliberately not `allCases` (that
    /// drives Wardrobe section order) nor `Accessory.rotationOrder` (that's the
    /// unlock difficulty ramp). A slot missing here vanishes from the pet.
    static let zOrder: [AccessorySlot] = [
        .pet,
        .eyes,
    ]
}

struct AccessoryDefinition {
    let name: String
    let weeklyStepGoal: Int
    let slot: AccessorySlot
    let view: (Mood, CGFloat, CGFloat) -> AnyView
}

enum Accessory {
    static let all: [AccessoryId: AccessoryDefinition] = [
        .coolShades: AccessoryDefinition(
            name: "Cool Shades",
            weeklyStepGoal: 25_000,
            slot: .eyes,
            view: { mood, size, spread in AnyView(
                Accessories.CoolShades(
                    mood: mood,
                    size: size,
                    spread: spread)
            )}
        ),
        .babyMochi: AccessoryDefinition(
            name: "Baby Mochi",
            weeklyStepGoal: 50_000,
            slot: .pet,
            view: { mood, size, spread in AnyView(
                Accessories.BabyMochi(
                    mood: mood,
                    size: size,
                    spread: spread)
            )}
        ),
    ]

    static let ids = AccessoryId.allCases

    static let rotationOrder: [AccessoryId] = [
        .coolShades,
        .babyMochi,
    ]

    static func define(_ id: AccessoryId) -> AccessoryDefinition {
        all[id]!
    }
}
