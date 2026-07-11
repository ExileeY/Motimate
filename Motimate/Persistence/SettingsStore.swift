import Foundation

final class SettingsStore: ObservableObject {
    @Published private(set) var goal: Int
    @Published private(set) var gameMode: GameMode
    @Published private(set) var petId: PetId
    @Published private(set) var autoNightEnabled: Bool
    @Published private(set) var hapticsEnabled: Bool
    @Published private(set) var ready: Bool

    #if DEBUG
    @Published var themeOverride: Theme? = nil
    #endif

    private let goalStore: PersistedStorage<Int>
    private let gameModeStore: PersistedStorage<GameMode>
    private let petStore: PersistedStorage<PetId>
    private let autoNightStore: PersistedStorage<Bool>
    private let hapticsStore: PersistedStorage<Bool>

    init(defaults: UserDefaults = .standard) {
        goalStore = GoalStorage.make(defaults: defaults)
        gameModeStore = GameModeStorage.make(defaults: defaults)
        petStore = PetStorage.make(defaults: defaults)
        autoNightStore = AutoNightStorage.make(defaults: defaults)
        hapticsStore = HapticsStorage.make(defaults: defaults)

        goal = goalStore.get()
        gameMode = gameModeStore.get()
        petId = petStore.get()
        autoNightEnabled = autoNightStore.get()
        hapticsEnabled = hapticsStore.get()
        ready = true
    }

    @discardableResult
    func setGoal(_ value: Int) -> Int {
        let normalized = goalStore.normalize(value)
        goal = normalized
        goalStore.set(normalized)
        return normalized
    }

    @discardableResult
    func setGameMode(_ value: GameMode) -> GameMode {
        let normalized = gameModeStore.normalize(value)
        gameMode = normalized
        gameModeStore.set(normalized)
        return normalized
    }

    @discardableResult
    func setPet(_ id: PetId) -> PetId {
        let normalized = petStore.normalize(id)
        petId = normalized
        petStore.set(normalized)
        return normalized
    }

    @discardableResult
    func setAutoNight(_ value: Bool) -> Bool {
        let normalized = autoNightStore.normalize(value)
        autoNightEnabled = normalized
        autoNightStore.set(normalized)
        return normalized
    }

    @discardableResult
    func setHaptics(_ value: Bool) -> Bool {
        let normalized = hapticsStore.normalize(value)
        hapticsEnabled = normalized
        hapticsStore.set(normalized)
        return normalized
    }

    func resolvedTheme(isDark: Bool) -> Theme {
        #if DEBUG
        if let themeOverride { return themeOverride }
        #endif
        return Theme.resolve(autoNightEnabled: autoNightEnabled, isDark: isDark)
    }
}
