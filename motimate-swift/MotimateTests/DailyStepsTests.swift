import XCTest
@testable import Motimate

/// Tests for `DailyStepsModel` (port of `src/steps/useDailySteps.ts`).
/// RN has no Jest test for the hook; this is the SwiftUI port's acceptance
/// suite, driving the model with a fake `StepReading`.
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
        let model = DailyStepsModel(settings: settings, reader: reader, hour: 9)

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
        let model = DailyStepsModel(settings: settings, reader: reader, hour: 9)

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.permission, .denied)
        XCTAssertFalse(model.loading)
        XCTAssertEqual(model.steps, 0) // never fetched
        XCTAssertFalse(reader.didSubscribe)
    }

    func testUnavailablePathDegradesGracefully() async {
        let reader = FakeStepReader(permission: .unavailable, todaySteps: 9_999)
        let model = DailyStepsModel(settings: settings, reader: reader, hour: 9)

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
        let model = DailyStepsModel(settings: settings, reader: reader, hour: 9)

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
        let model = DailyStepsModel(settings: settings, reader: reader, hour: 9)

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
        let model = DailyStepsModel(settings: settings, reader: reader, hour: MORNING_END_HOUR)

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.mood, .sad)
    }

    func testRealModeEnergeticBeforeNoonStaysEnergetic() async {
        settings.setGameMode(.real)
        let reader = FakeStepReader(permission: .granted, todaySteps: 0)
        let model = DailyStepsModel(settings: settings, reader: reader, hour: MORNING_END_HOUR - 1)

        model.start()
        await waitForResolution(model)

        XCTAssertEqual(model.mood, .energetic)
    }
}

/// Configurable `StepReading` double for driving `DailyStepsModel` in tests.
private final class FakeStepReader: StepReading {
    private let permission: PermissionState
    private let todaySteps: Int
    private var onSteps: ((Int) -> Void)?
    private(set) var didSubscribe = false

    init(permission: PermissionState, todaySteps: Int) {
        self.permission = permission
        self.todaySteps = todaySteps
    }

    func requestPermission() async -> PermissionState { permission }

    func getTodaySteps() async -> Int { todaySteps }

    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void {
        didSubscribe = true
        self.onSteps = onSteps
        return { [weak self] in self?.onSteps = nil }
    }

    /// Simulate a live pedometer update.
    func emit(_ steps: Int) {
        onSteps?(steps)
    }
}
