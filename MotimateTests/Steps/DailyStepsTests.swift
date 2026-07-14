import XCTest
@testable import Motimate

@MainActor
final class DailyStepsTests: XCTestCase {
    private let goal = 10_000
    private var defaults: UserDefaults!
    private var settings: SettingsStore!

    override func setUp() {
        super.setUp()
        // Isolated, in-memory defaults so tests never touch real persistence.
        defaults = UserDefaults(suiteName: "DailyStepsTests.\(UUID().uuidString)")
        settings = SettingsStore(defaults: defaults)
        settings.setGoal(goal)
    }

    override func tearDown() {
        settings = nil
        defaults = nil
        super.tearDown()
    }

    /// Lets a test `await` the async `start()` lifecycle deterministically.
    private func waitForResolution(_ model: DailyStepsModel) async {
        var attempts = 0
        while model.loading && attempts < 100 {
            try? await Task.sleep(nanoseconds: 5_000_000) // 5ms
            attempts += 1
        }
    }

    // MARK: - Granted path

    func testGrantedPathFansOutSteps() async {
        let reader = FakeStepReader(permission: .granted, todaySteps: 2_500)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.permission, .granted)
        XCTAssertFalse(model.loading)
        XCTAssertEqual(model.steps, 2_500)
        XCTAssertEqual(model.mood, .calm) // 2500 / 10000 = 0.25 → past energetic cap (0.2)
        XCTAssertEqual(model.progress, 0.25, accuracy: 0.0001)
    }

    // MARK: - Denied / unavailable paths

    func testDeniedPathDegradesGracefully() async {
        let reader = FakeStepReader(permission: .denied, todaySteps: 9_999)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.permission, .denied)
        XCTAssertFalse(model.loading)
        XCTAssertEqual(model.steps, 0) // never fetched
        XCTAssertFalse(reader.didSubscribe)
    }

    func testUnavailablePathDegradesGracefully() async {
        let reader = FakeStepReader(permission: .unavailable, todaySteps: 9_999)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.permission, .unavailable)
        XCTAssertFalse(model.loading)
        XCTAssertEqual(model.steps, 0)
        XCTAssertFalse(reader.didSubscribe)
    }

    // MARK: - Live updates

    func testLiveUpdateRecomputesMoodAndProgress() async {
        let reader = FakeStepReader(permission: .granted, todaySteps: 0)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.mood, .energetic) // 0 steps
        XCTAssertTrue(reader.didSubscribe)

        reader.emit(7_000) // 0.7 → past calm cap (0.64)
        // Give the @MainActor hop a tick to land.
        try? await Task.sleep(nanoseconds: 10_000_000)

        XCTAssertEqual(model.steps, 7_000)
        XCTAssertEqual(model.mood, .tired)
        XCTAssertEqual(model.progress, 0.7, accuracy: 0.0001)
    }

    // MARK: - Settings reactivity

    func testGoalChangeRecomputesMood() async {
        let reader = FakeStepReader(permission: .granted, todaySteps: 2_500)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.start()
        await waitForResolution(model)
        XCTAssertEqual(model.mood, .calm) // 2500 / 10000 = 0.25

        settings.setGoal(50_000) // 2500 / 50000 = 0.05 → energetic
        // Combine publishes synchronously on the same runloop; mood is updated.
        XCTAssertEqual(model.mood, .energetic)
    }

    // MARK: - SAD overlay (REAL mode + energetic + past noon)

    func testRealModeEnergeticPastNoonTurnsSad() async {
        settings.setGameMode(.real)
        let reader = FakeStepReader(permission: .granted, todaySteps: 0)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: MORNING_END_HOUR))

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.mood, .sad)
    }

    func testRealModeEnergeticBeforeNoonStaysEnergetic() async {
        settings.setGameMode(.real)
        let reader = FakeStepReader(permission: .granted, todaySteps: 0)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: MORNING_END_HOUR - 1))

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.mood, .energetic)
    }

    // MARK: - Foreground refresh (re-anchor after background across a boundary)

    /// Lets a test `await` the async work `refresh()` schedules on `@MainActor`.
    private func tick() async {
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
    }

    func testClockCrossingNoonFlipsToSad() async {
        settings.setGameMode(.real)
        let reader = FakeStepReader(permission: .granted, todaySteps: 0)
        let clock = FakeHourClock(hour: MORNING_END_HOUR - 1)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: clock)

        model.start()
        await waitForResolution(model)
        XCTAssertEqual(model.mood, .energetic)

        clock.push(MORNING_END_HOUR) // hour crosses noon (e.g. a foreground refresh re-reads it)
        await tick()

        XCTAssertEqual(model.mood, .sad)
    }

    func testRefreshReAnchorsStepsAndResubscribes() async {
        let reader = FakeStepReader(permission: .granted, todaySteps: 5_000)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.start()
        await waitForResolution(model)
        XCTAssertEqual(model.steps, 5_000)
        XCTAssertEqual(reader.subscribeCount, 1)

        reader.todaySteps = 0 // new day: yesterday's 5k is gone
        model.refresh()
        await tick()

        XCTAssertEqual(model.steps, 0)
        XCTAssertEqual(model.mood, .energetic)
        XCTAssertEqual(reader.subscribeCount, 2)   // re-subscribed
        XCTAssertEqual(reader.unsubscribeCount, 1) // old stream torn down

        reader.emit(300) // the *new* subscription is the live one
        await tick()
        XCTAssertEqual(model.steps, 300)
    }

    func testRefreshBeforeStartIsNoOp() async {
        let reader = FakeStepReader(permission: .granted, todaySteps: 5_000)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: FakeHourClock(hour: 9))

        model.refresh()
        await tick()

        XCTAssertNil(model.permission)
        XCTAssertTrue(model.loading)
        XCTAssertEqual(reader.subscribeCount, 0)
    }

    func testClockChangeWhenDeniedStillRecomputesMood() async {
        settings.setGameMode(.real)
        let reader = FakeStepReader(permission: .denied, todaySteps: 9_999)
        let clock = FakeHourClock(hour: MORNING_END_HOUR - 1)
        let model = DailyStepsModel(settings: settings, reader: reader, clock: clock)

        model.start()
        await waitForResolution(model)
        XCTAssertEqual(model.mood, .energetic)

        clock.push(MORNING_END_HOUR) // hour advances even though the pedometer is denied
        await tick()

        XCTAssertEqual(model.mood, .sad)
        XCTAssertFalse(reader.didSubscribe)
    }
}

private final class FakeStepReader: StepReading {
    private let permission: PermissionState

    var todaySteps: Int // Mutable so tests can simulate a new day.
    private var onSteps: ((Int) -> Void)?

    private(set) var subscribeCount = 0
    private(set) var unsubscribeCount = 0
    var didSubscribe: Bool { subscribeCount > 0 }

    init(permission: PermissionState, todaySteps: Int) {
        self.permission = permission
        self.todaySteps = todaySteps
    }

    func requestPermission() async -> PermissionState { permission }

    func getTodaySteps() async -> Int { todaySteps }

    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void {
        subscribeCount += 1
        self.onSteps = onSteps

        return { [weak self] in
            self?.unsubscribeCount += 1
            self?.onSteps = nil
        }
    }

    func emit(_ steps: Int) {
        onSteps?(steps)
    }
}
