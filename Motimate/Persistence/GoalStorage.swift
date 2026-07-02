import Foundation

let GOAL_DEFAULT = 12_500
let GOAL_MIN = 1_000
let GOAL_MAX = 50_000

func normalizeGoal(_ goal: Double) -> Int {
    guard goal.isFinite else { return GOAL_DEFAULT }
    return min(max(Int(goal.rounded()), GOAL_MIN), GOAL_MAX)
}

func makeGoalStorage(defaults: UserDefaults = .standard) -> PersistedStorage<Int> {
    PersistedStorage(
        key: "motimate.goal",
        decode: { stored in stored.flatMap { Double($0) }.map { Int($0.rounded()) } ?? GOAL_DEFAULT },
        encode: { String($0) },
        normalize: { normalizeGoal(Double($0)) },
        fallback: GOAL_DEFAULT,
        defaults: defaults
    )
}
