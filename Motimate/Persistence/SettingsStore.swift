import Foundation

final class SettingsStore: ObservableObject {
    @Published private(set) var goal: Int
    @Published private(set) var gameMode: GameMode
    @Published private(set) var petId: PetId
    @Published private(set) var ready: Bool

    private let goalStore: PersistedStorage<Int>
    private let gameModeStore: PersistedStorage<GameMode>
    private let petStore: PersistedStorage<PetId>

    init(defaults: UserDefaults = .standard) {
        goalStore = makeGoalStorage(defaults: defaults)
        gameModeStore = makeGameModeStorage(defaults: defaults)
        petStore = makePetStorage(defaults: defaults)

        goal = goalStore.get()
        gameMode = gameModeStore.get()
        petId = petStore.get()
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
}
