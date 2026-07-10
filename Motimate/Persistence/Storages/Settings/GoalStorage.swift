import Foundation

enum GoalStorage {
    static let defaultValue = 12_500
    static let minValue = 1_000
    static let maxValue = 50_000

    static func decode(_ value: String?) -> Int {
        value.flatMap { Double($0) }.map { Int($0.rounded()) } ?? defaultValue
    }

    static func encode(_ value: Int) -> String {
        String(value)
    }

    static func normalize(_ value: Int) -> Int {
        normalize(Double(value))
    }

    static func normalize(_ value: Double) -> Int {
        guard value.isFinite else { return defaultValue }
        return MathUtils.clamp(Int(value.rounded()), min: minValue, max: maxValue)
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<Int> {
        PersistedStorage(
            key: "motimate.goal",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
