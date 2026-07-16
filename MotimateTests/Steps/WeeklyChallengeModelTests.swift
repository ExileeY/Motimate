import XCTest
@testable import Motimate

@MainActor
final class WeeklyChallengeModelTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "WeeklyChallengeModelTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeModel(
        priorDaysSteps: Int = 0,
        accessories: AccessoryStore? = nil
    ) -> (WeeklyChallengeModel, AccessoryStore, FakeRangeStepReader) {
        let settings = SettingsStore()
        let accessoryStore = accessories ?? AccessoryStore(defaults: defaults)
        let reader = FakeRangeStepReader(rangeSteps: priorDaysSteps)
        let model = WeeklyChallengeModel(
            accessories: accessoryStore,
            dailySteps: DailyStepsModel(
                settings: settings,
                reader: FakeRangeStepReader(rangeSteps: 0),
                clock: FakeHourClock(hour: 9)
            ),
            store: WeeklyChallengeStore(defaults: defaults),
            reader: reader
        )
        return (model, accessoryStore, reader)
    }

    private func waitForLoad(_ model: WeeklyChallengeModel) async {
        for _ in 0..<100 {
            if !model.loading { return }
            try? await Task.sleep(nanoseconds: 5_000_000)
        }
        XCTFail("model never finished loading")
    }

    // MARK: - Challenge selection

    func testFreshInstallOffersTheFirstRotationItem() async {
        let (model, _, _) = makeModel()

        model.start()
        await waitForLoad(model)

        XCTAssertEqual(model.weeklyAccessory, Accessory.rotationOrder.first)
    }

    func testAllOwnedYieldsNoChallenge() async {
        let accessories = AccessoryStore(defaults: defaults)
        AccessoryId.allCases.forEach { accessories.unlock($0) }

        let (model, _, _) = makeModel(accessories: accessories)

        model.start()
        await waitForLoad(model)

        XCTAssertNil(model.weeklyAccessory)
    }

    // MARK: - Weekly steps

    func testWeeklyStepsIsPriorDaysPlusToday() async {
        let (model, _, _) = makeModel(priorDaysSteps: 9_000)

        model.start()
        await waitForLoad(model)

        XCTAssertEqual(model.weeklySteps, 9_000)
    }

    func testPriorDaysRangeSpansThisWeeksMondayToLocalMidnight() async {
        let (model, _, reader) = makeModel(priorDaysSteps: 1_000)

        model.start()
        await waitForLoad(model)

        guard let query = reader.rangeQueries.first else {
            XCTAssertEqual(WeekMath.startOfWeek(for: Date()), startOfToday())
            return
        }

        XCTAssertEqual(query.from, WeekMath.startOfWeek(for: Date()))
        XCTAssertEqual(query.to, startOfToday())
    }

    // MARK: - Unlock

    func testUnlocksWhenTheWeeklyGoalIsMet() async {
        let item = Accessory.rotationOrder.first!
        let goal = Accessory.define(item).weeklyStepGoal

        let (model, accessories, _) = makeModel(priorDaysSteps: goal)

        model.start()
        await waitForLoad(model)

        XCTAssertTrue(accessories.isOwned(item))
    }

    func testDoesNotUnlockBelowTheGoal() async {
        let item = Accessory.rotationOrder.first!
        let goal = Accessory.define(item).weeklyStepGoal

        let (model, accessories, _) = makeModel(priorDaysSteps: goal - 1)

        model.start()
        await waitForLoad(model)

        XCTAssertFalse(accessories.isOwned(item))
    }

    func testOnlyTheFrozenItemUnlocksEvenWhenABiggerGoalIsMet() async {
        let itemCurrent = Accessory.rotationOrder.first!
        let itemMaximum = Accessory.all.values.map(\.weeklyStepGoal).max()!

        let (model, accessories, _) = makeModel(priorDaysSteps: itemMaximum * 2)

        model.start()
        await waitForLoad(model)

        XCTAssertEqual(accessories.owned, [itemCurrent])
    }

    func testEarnedItemStaysAsTheChallengeForTheRestOfTheWeek() async {
        let itemCurrent = Accessory.rotationOrder.first!
        let itemGoal = Accessory.define(itemCurrent).weeklyStepGoal

        let (model, accessories, _) = makeModel(priorDaysSteps: itemGoal)

        model.start()
        await waitForLoad(model)

        XCTAssertTrue(accessories.isOwned(itemCurrent))
        XCTAssertEqual(model.weeklyAccessory, itemCurrent)

        model.refresh()
        await waitForLoad(model)

        XCTAssertEqual(model.weeklyAccessory, itemCurrent)
    }

    // MARK: - Debug seam

    #if DEBUG
    func testDebugSetWeeklyStepsDrivesTheUnlock() async {
        let item = Accessory.rotationOrder.first!
        let (model, accessories, _) = makeModel()

        model.start()
        await waitForLoad(model)
        model.debugSetWeeklySteps(Accessory.define(item).weeklyStepGoal)

        XCTAssertEqual(model.weeklySteps, Accessory.define(item).weeklyStepGoal)
        XCTAssertTrue(accessories.isOwned(item))
    }

    func testDebugAdvanceWeekRotatesToTheNextUnownedItem() async {
        let item = Accessory.rotationOrder.first!
        let (model, _, _) = makeModel()

        model.start()
        await waitForLoad(model)
        model.debugSetWeeklySteps(Accessory.define(item).weeklyStepGoal)
        model.debugAdvanceWeek()

        XCTAssertNotEqual(model.weeklyAccessory, item)
        XCTAssertNotNil(model.weeklyAccessory)
        XCTAssertEqual(model.weeklySteps, 0, "a new week starts the count over")
    }
    #endif
}

private final class FakeRangeStepReader: StepReading {
    var rangeSteps: Int
    private(set) var rangeQueries: [(from: Date, to: Date)] = []

    init(rangeSteps: Int) {
        self.rangeSteps = rangeSteps
    }

    func requestPermission() async -> PermissionState { .granted }

    func getSteps(from: Date, to: Date) async -> Int {
        rangeQueries.append((from, to))
        return rangeSteps
    }

    func getTodaySteps() async -> Int { 0 }

    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void { {} }
}
