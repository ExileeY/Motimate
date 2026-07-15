import Foundation

 final class WeeklyChallengeStore {
    private let originStore: PersistedStorage<Date?>
    private let indexStore: PersistedStorage<Int?>
    private let itemStore: PersistedStorage<AccessoryId?>

    init(defaults: UserDefaults = .standard) {
        originStore = WeekOriginStorage.make(defaults: defaults)
        indexStore = WeekIndexStorage.make(defaults: defaults)
        itemStore = WeekItemStorage.make(defaults: defaults)
    }

    func weekIndex(on date: Date = Date()) -> Int {
        WeekMath.weeksBetween(resolveOrigin(on: date), date)
    }

    func resolve(owned: Set<AccessoryId>, on date: Date = Date()) -> AccessoryId? {
        let index = weekIndex(on: date)

        if indexStore.get() == index, let frozen = itemStore.get() {
            return frozen
        }

        let item = WeeklyChallenge.select(weekIndex: index, owned: owned)
        indexStore.set(index)
        itemStore.set(item)
        return item
    }

    private func resolveOrigin(on date: Date) -> Date {
        if let stored = originStore.get() { return stored }

        let seeded = WeekMath.startOfWeek(for: date)
        originStore.set(seeded)
        return seeded
    }

    #if DEBUG
    func debugAdvance(weeks: Int, on date: Date = Date()) {
        let current = resolveOrigin(on: date)
        originStore.set(current.addingTimeInterval(Double(weeks) * -7 * 24 * 60 * 60))
    }

    func reset() {
        originStore.clear()
        indexStore.clear()
        itemStore.clear()
    }
    #endif
}
