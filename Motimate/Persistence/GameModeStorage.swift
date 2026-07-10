import Foundation

enum GameModeStorage {
    static let defaultValue: GameMode = GAMEMODE_ID_DEFAULT
    static let ids = GameMode.allCases

    static func decode(_ value: String?) -> GameMode {
        value.flatMap { GameMode(rawValue: $0) } ?? defaultValue
    }

    static func encode(_ value: GameMode) -> String {
        value.rawValue
    }

    static func normalize(_ value: GameMode?) -> GameMode {
        guard let value, ids.contains(value) else { return defaultValue }
        return value
    }

    static func make(defaults: UserDefaults = .standard) -> PersistedStorage<GameMode> {
        PersistedStorage(
            key: "motimate.mode",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: defaultValue,
            defaults: defaults
        )
    }
}
