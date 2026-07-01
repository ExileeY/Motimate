import Foundation

let GAME_MODE_DEFAULT: GameMode = GAMEMODE_ID_DEFAULT
let GAME_MODE_IDS = GameMode.allCases

func normalizeGameMode(_ value: GameMode?) -> GameMode {
    guard let value, GAME_MODE_IDS.contains(value) else { return GAME_MODE_DEFAULT }
    return value
}

func makeGameModeStorage(defaults: UserDefaults = .standard) -> PersistedStorage<GameMode> {
    PersistedStorage(
        key: "motimate.mode",
        decode: { stored in stored.flatMap { GameMode(rawValue: $0) } ?? GAME_MODE_DEFAULT },
        encode: { $0.rawValue },
        normalize: { normalizeGameMode($0) },
        fallback: GAME_MODE_DEFAULT,
        defaults: defaults
    )
}
