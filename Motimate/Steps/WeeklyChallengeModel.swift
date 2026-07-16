import Combine
import Foundation

@MainActor
final class WeeklyChallengeModel: ObservableObject {
    @Published private(set) var loading: Bool = true
    @Published private(set) var weeklySteps: Int = 0
    @Published private(set) var weeklyAccessory: AccessoryId?

    private let accessories: AccessoryStore
    private let dailySteps: DailyStepsModel
    private let store: WeeklyChallengeStore
    private let reader: StepReading

    private var priorDaysSteps = 0
    private var cancellables = Set<AnyCancellable>()
    private var started = false

    #if DEBUG
    private var debugStepsOverride: Int?
    #endif

    init(
        accessories: AccessoryStore,
        dailySteps: DailyStepsModel,
        store: WeeklyChallengeStore = WeeklyChallengeStore(),
        reader: StepReading = StepReader()
    ) {
        self.accessories = accessories
        self.dailySteps = dailySteps
        self.store = store
        self.reader = reader

        dailySteps.$steps
            .sink { [weak self] steps in self?.recompute(todaySteps: steps) }
            .store(in: &cancellables)

        resolveWeeklyAccessory()
    }

    func start() {
        guard !started else { return }
        started = true

        Task { [weak self] in
            await self?.load()
        }
    }

    func refresh() {
        Task { [weak self] in
            await self?.load()
        }
    }

    private func load() async {
        let now = Date()

        let startOfWeekDate = WeekMath.startOfWeek(for: now)
        let startOfTodayDate = startOfToday(now)

        priorDaysSteps = startOfWeekDate < startOfTodayDate
            ? await reader.getSteps(from: startOfWeekDate, to: startOfTodayDate)
            : 0
        loading = false

        resolveWeeklyAccessory()
        recompute()
    }

    private func resolveWeeklyAccessory() {
        weeklyAccessory = store.resolve(owned: accessories.owned)
    }

    private func recompute(todaySteps: Int? = nil) {
        #if DEBUG
        if let debugStepsOverride {
            weeklySteps = debugStepsOverride
            maybeUnlock()

            return
        }
        #endif

        weeklySteps = priorDaysSteps + (todaySteps ?? dailySteps.steps)
        maybeUnlock()
    }

    private func maybeUnlock() {
        guard !loading, let weeklyAccessory else { return }
        guard weeklySteps >= Accessory.define(weeklyAccessory).weeklyStepGoal else { return }

        accessories.unlock(weeklyAccessory)
    }

    #if DEBUG
    func debugSetWeeklySteps(_ steps: Int) {
        debugStepsOverride = steps
        loading = false
        recompute()
    }

    func debugAddWeeklySteps(_ steps: Int) {
        debugSetWeeklySteps(weeklySteps + steps)
    }

    func debugAdvanceWeek() {
        store.debugAdvance(weeks: 1)
        debugStepsOverride = nil
        priorDaysSteps = 0
        resolveWeeklyAccessory()
        recompute(todaySteps: 0)
    }

    func debugReset() {
        store.reset()
        accessories.reset()
        debugStepsOverride = nil
        priorDaysSteps = 0
        resolveWeeklyAccessory()
        recompute(todaySteps: 0)
    }
    #endif
}
