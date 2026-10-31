import XCTest
@testable import Motimate

final class SettingsStoreTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "SettingsStoreTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    func testFreshStoreHydratesToDefaults() {
        let store = SettingsStore(defaults: defaults)
        XCTAssertTrue(store.ready)
        XCTAssertEqual(store.goal, GoalStorage.defaultValue)
        XCTAssertEqual(store.petId, PetStorage.defaultValue)
        XCTAssertEqual(store.gameMode, GameModeStorage.defaultValue)
        XCTAssertEqual(store.hapticsTabEnabled, HapticsTapStorage.defaultValue)
        XCTAssertEqual(store.hapticsAnimationEnabled, HapticsAnimationStorage.defaultValue)
    }

    func testSetTapHapticsPublishesAndReturns() {
        let store = SettingsStore(defaults: defaults)
        let returned = store.setHapticsTap(true)
        XCTAssertTrue(returned)
        XCTAssertTrue(store.hapticsTabEnabled)
    }

    func testSetAnimationHapticsPublishesAndReturns() {
        let store = SettingsStore(defaults: defaults)
        let returned = store.setHapticsAnimation(true)
        XCTAssertTrue(returned)
        XCTAssertTrue(store.hapticsAnimationEnabled)
    }

    func testSetGoalNormalizesPublishesAndReturns() {
        let store = SettingsStore(defaults: defaults)
        let returned = store.setGoal(60_000)
        XCTAssertEqual(returned, GoalStorage.maxValue)
        XCTAssertEqual(store.goal, GoalStorage.maxValue)
    }

    func testSettingsPersistAcrossReinstantiation() {
        let store = SettingsStore(defaults: defaults)
        store.setGoal(20_000)
        store.setPet(.tomato)
        store.setGameMode(.real)
        store.setHapticsTap(true)
        store.setHapticsAnimation(true)

        let reloaded = SettingsStore(defaults: defaults)
        XCTAssertEqual(reloaded.goal, 20_000)
        XCTAssertEqual(reloaded.petId, .tomato)
        XCTAssertEqual(reloaded.gameMode, .real)
        XCTAssertTrue(reloaded.hapticsTabEnabled)
        XCTAssertTrue(reloaded.hapticsAnimationEnabled)
    }

    // MARK: - Scenery

    func testFreshStoreIsClassicWithAutoNightOn() {
        let store = SettingsStore(defaults: defaults)
        XCTAssertEqual(store.sceneryId, .classic)
        XCTAssertTrue(store.autoNightEnabled)
    }

    func testSetMeadowTurnsAutoNightOffAndPersistsBoth() {
        SettingsStore(defaults: defaults).setScenery(.meadow)

        let reloaded = SettingsStore(defaults: defaults)
        XCTAssertEqual(reloaded.sceneryId, .meadow)
        XCTAssertFalse(reloaded.autoNightEnabled)
    }

    func testSetClassicLeavesAutoNightAlone() {
        let store = SettingsStore(defaults: defaults)
        store.setScenery(.classic)
        XCTAssertTrue(store.autoNightEnabled)

        store.setAutoNight(false)
        store.setScenery(.classic)
        XCTAssertFalse(store.autoNightEnabled)
    }

    func testEnablingAutoNightResetsSceneryToClassic() {
        let store = SettingsStore(defaults: defaults)
        store.setScenery(.meadow)

        store.setAutoNight(true)

        XCTAssertEqual(store.sceneryId, .classic)
        XCTAssertTrue(store.autoNightEnabled)
        let reloaded = SettingsStore(defaults: defaults)
        XCTAssertEqual(reloaded.sceneryId, .classic)
        XCTAssertTrue(reloaded.autoNightEnabled)
    }

    func testDisablingAutoNightLeavesSceneryAlone() {
        let store = SettingsStore(defaults: defaults)
        store.setScenery(.meadow)

        store.setAutoNight(false)

        XCTAssertEqual(store.sceneryId, .meadow)
        XCTAssertFalse(store.autoNightEnabled)
    }

    func testConfirmsDisablingAutoNightOnlyWhenPickingACustomSceneryWithAutoNightOn() {
        let store = SettingsStore(defaults: defaults)
        XCTAssertTrue(store.shouldConfirmDisablingAutoNight(for: .meadow))
        XCTAssertFalse(store.shouldConfirmDisablingAutoNight(for: .classic))

        store.setAutoNight(false)
        XCTAssertFalse(store.shouldConfirmDisablingAutoNight(for: .meadow))
    }

    func testConfirmsEnablingAutoNightOnlyWhileACustomSceneryIsActive() {
        let store = SettingsStore(defaults: defaults)
        XCTAssertFalse(store.shouldConfirmEnablingAutoNight) // classic, auto-night on

        store.setAutoNight(false)
        XCTAssertFalse(store.shouldConfirmEnablingAutoNight) // classic, auto-night off

        store.setScenery(.meadow)
        XCTAssertTrue(store.shouldConfirmEnablingAutoNight)
    }

    func testNightAlwaysDrawsClassic() {
        let store = SettingsStore(defaults: defaults)
        store.setScenery(.meadow)
        XCTAssertEqual(store.activeScenery(for: .day), .meadow)
        XCTAssertEqual(store.activeScenery(for: .night), .classic)
    }
}
