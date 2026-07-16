import SwiftUI

enum AccessoryId: String, CaseIterable {
    case coolShades
    case threeDGlasses
    case heartShades
    case babyMochi
    case babySchnauzer
    case babyDuckling
}

enum AccessorySlot: String, CaseIterable {
    case eyes
    case pet

    static let zOrder: [AccessorySlot] = [
        .pet,
        .eyes,
    ]

    var displayTitle: String {
        switch self {
        case .eyes: return "Eyes"
        case .pet: return "Pet"
        }
    }
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
        .threeDGlasses: AccessoryDefinition(
            name: "3D Glasses",
            weeklyStepGoal: 35_000,
            slot: .eyes,
            view: { mood, size, spread in AnyView(
                Accessories.ThreeDGlasses(
                    mood: mood,
                    size: size,
                    spread: spread)
            )}
        ),
        .heartShades: AccessoryDefinition(
            name: "Heart Sunglasses",
            weeklyStepGoal: 40_000,
            slot: .eyes,
            view: { mood, size, spread in AnyView(
                Accessories.HeartGlasses(
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
        .babySchnauzer: AccessoryDefinition(
            name: "Baby Schnauzer",
            weeklyStepGoal: 85_000,
            slot: .pet,
            view: { mood, size, spread in AnyView(
                Accessories.BabySchnauzer(
                    mood: mood,
                    size: size,
                    spread: spread)
            )}
        ),
        .babyDuckling: AccessoryDefinition(
            name: "Baby Duckling",
            weeklyStepGoal: 100_000,
            slot: .pet,
            view: { mood, size, spread in AnyView(
                Accessories.BabyDuckling(
                    mood: mood,
                    size: size,
                    spread: spread)
            )}
        ),
    ]

    static let ids = AccessoryId.allCases

    static let rotationOrder: [AccessoryId] = [
        .coolShades,
        .threeDGlasses,
        .heartShades,
        .babyMochi,
        .babySchnauzer,
        .babyDuckling
    ]

    static func define(_ id: AccessoryId) -> AccessoryDefinition {
        all[id]!
    }
}
