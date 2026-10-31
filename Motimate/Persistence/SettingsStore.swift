import Foundation

final class SettingsStore: ObservableObject {
    @Published private(set) var goal: Int
    @Published private(set) var gameMode: GameMode
    @Published private(set) var sceneryId: SceneryId
    @Published private(set) var petId: PetId
    @Published private(set) var autoNightEnabled: Bool
    @Published private(set) var hapticsTabEnabled: Bool
    @Published private(set) var hapticsAnimationEnabled: Bool
    @Published private(set) var ready: Bool

    #if DEBUG
    @Published var themeOverride: Theme? = nil
    #endif

    private let goalStore: PersistedStorage<Int>
    private let gameModeStore: PersistedStorage<GameMode>
    private let sceneryStore: PersistedStorage<SceneryId>
    private let petStore: PersistedStorage<PetId>
    private let autoNightStore: PersistedStorage<Bool>
    private let hapticsTapStore: PersistedStorage<Bool>
    private let hapticsAnimationStore: PersistedStorage<Bool>

    init(defaults: UserDefaults = .standard) {
        goalStore = GoalStorage.make(defaults: defaults)
        gameModeStore = GameModeStorage.make(defaults: defaults)
        sceneryStore = SceneryStorage.make(defaults: defaults)
        petStore = PetStorage.make(defaults: defaults)
        autoNightStore = AutoNightStorage.make(defaults: defaults)
        hapticsTapStore = HapticsTapStorage.make(defaults: defaults)
        hapticsAnimationStore = HapticsAnimationStorage.make(defaults: defaults)

        goal = goalStore.get()
        gameMode = gameModeStore.get()
        sceneryId = sceneryStore.get()
        petId = petStore.get()
        autoNightEnabled = autoNightStore.get()
        hapticsTabEnabled = hapticsTapStore.get()
        hapticsAnimationEnabled = hapticsAnimationStore.get()
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
    private func writeAutoNight(_ value: Bool) -> Bool {
        let normalized = autoNightStore.normalize(value)
        autoNightEnabled = normalized
        autoNightStore.set(normalized)
        return normalized
    }

    /// Auto-night and a custom scenery never coexist, so switching auto-night on
    /// falls back to classic. Ask first — see `shouldConfirmEnablingAutoNight`.
    @discardableResult
    func setAutoNight(_ value: Bool) -> Bool {
        let newValue = writeAutoNight(value)

        if sceneryId.requiresDisablingAutoNight && newValue {
            writeScenery(.classic)
        }

        return newValue
    }

    @discardableResult
    func setHapticsTap(_ value: Bool) -> Bool {
        let normalized = hapticsTapStore.normalize(value)
        hapticsTabEnabled = normalized
        hapticsTapStore.set(normalized)
        return normalized
    }

    @discardableResult
    func setHapticsAnimation(_ value: Bool) -> Bool {
        let normalized = hapticsAnimationStore.normalize(value)
        hapticsAnimationEnabled = normalized
        hapticsAnimationStore.set(normalized)
        return normalized
    }

    @discardableResult
    private func writeScenery(_ id: SceneryId) -> SceneryId {
        let normalized = sceneryStore.normalize(id)
        sceneryId = normalized
        sceneryStore.set(normalized)
        return normalized
    }

    /// A non-classic scenery has its own look, so picking one also switches
    /// auto-night off. Ask first — see `shouldConfirmDisablingAutoNight(for:)`.
    @discardableResult
    func setScenery(_ id: SceneryId) -> SceneryId {
        let newValue = writeScenery(id)

        if newValue.requiresDisablingAutoNight {
            writeAutoNight(false)
        }

        return newValue
    }

    /// Night (only reachable via the DEBUG `themeOverride`) always draws classic.
    func activeScenery(for theme: Theme) -> SceneryId {
        theme == .night ? .classic : sceneryId
    }

    func shouldConfirmDisablingAutoNight(for id: SceneryId) -> Bool {
        autoNightEnabled && id.requiresDisablingAutoNight
    }

    var shouldConfirmEnablingAutoNight: Bool {
        !autoNightEnabled && sceneryId.requiresDisablingAutoNight
    }

    func resolvedTheme(isDark: Bool) -> Theme {
        #if DEBUG
        if let themeOverride { return themeOverride }
        #endif
        return Theme.resolve(autoNightEnabled: autoNightEnabled, isDark: isDark)
    }
}
