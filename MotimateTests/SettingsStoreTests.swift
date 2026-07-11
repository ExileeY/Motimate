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
        XCTAssertEqual(store.hapticsEnabled, HapticsStorage.defaultValue)
    }

    func testSetHapticsPublishesAndReturns() {
        let store = SettingsStore(defaults: defaults)
        let returned = store.setHaptics(true)
        XCTAssertTrue(returned)
        XCTAssertTrue(store.hapticsEnabled)
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
        store.setHaptics(true)

        let reloaded = SettingsStore(defaults: defaults)
        XCTAssertEqual(reloaded.goal, 20_000)
        XCTAssertEqual(reloaded.petId, .tomato)
        XCTAssertEqual(reloaded.gameMode, .real)
        XCTAssertTrue(reloaded.hapticsEnabled)
    }
}
