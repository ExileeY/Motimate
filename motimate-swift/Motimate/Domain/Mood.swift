enum Mood: String, CaseIterable {
    case energetic
    case calm
    case tired
    case sad
}

let MORNING_END_HOUR = 12

let MOOD_MAX_RATIO: [Mood: Double] = [
    .energetic: 0.2,
    .calm: 0.64,
    .tired: .infinity,
]

private func stepMood(steps: Int, goal: Int) -> Mood {
    let baseMoods: [Mood] = [
        .energetic,
        .calm,
        .tired
    ]

  return baseMoods.first { Double(steps) < Double(goal) * MOOD_MAX_RATIO[$0]! }!
}

enum StepsConvertor {
    static func toMood(steps: Int, goal: Int, mode: GameMode, hour: Int) -> Mood {
        let mood = stepMood(steps: steps, goal: goal)

        return mode == .real && mood == .energetic && hour >= MORNING_END_HOUR
            ? .sad
            : mood
    }

    static func toProgress(steps: Int, goal: Int) -> Double {
        return min(Double(steps) / Double(goal), 1)
    }
}
