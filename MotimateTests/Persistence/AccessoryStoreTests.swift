import XCTest
@testable import Motimate

final class AccessoryStoreTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "AccessoryStoreTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    // MARK: - Progress

    func testProgressMath() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertEqual(store.progress(.coolShades, steps: 0), 0, accuracy: 0.0001)
        XCTAssertEqual(store.progress(.coolShades, steps: 4_000), 0.5, accuracy: 0.0001)
        XCTAssertEqual(store.progress(.coolShades, steps: 8_000), 1, accuracy: 0.0001)
        XCTAssertEqual(store.progress(.coolShades, steps: 20_000), 1, accuracy: 0.0001)
    }

    // MARK: - Unlock

    func testEvaluateUnlocksAtGoal() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertFalse(store.isOwned(.coolShades))

        let newly = store.evaluate(steps: 8_000)
        XCTAssertEqual(newly, [.coolShades])
        XCTAssertTrue(store.isOwned(.coolShades))
    }

    func testEvaluateBelowGoalDoesNotUnlock() {
        let store = AccessoryStore(defaults: defaults)
        let newly = store.evaluate(steps: 7_999)
        XCTAssertTrue(newly.isEmpty)
        XCTAssertFalse(store.isOwned(.coolShades))
    }

    func testUnlockPersistsAcrossReinstantiation() {
        let store = AccessoryStore(defaults: defaults)
        store.evaluate(steps: 8_000)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertTrue(reloaded.isOwned(.coolShades))
    }

    func testOwnershipIsDayIndependentAndPermanent() {
        let store = AccessoryStore(defaults: defaults)
        store.evaluate(steps: 8_000)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertTrue(reloaded.isOwned(.coolShades))
        reloaded.evaluate(steps: 0)
        XCTAssertTrue(reloaded.isOwned(.coolShades))
    }

    func testEvaluateIsIdempotent() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertEqual(store.evaluate(steps: 8_000), [.coolShades])
        XCTAssertTrue(store.evaluate(steps: 8_000).isEmpty)
    }

    // MARK: - Equip

    func testEquipRequiresOwnership() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertNil(store.equip(.coolShades)) // not owned → no-op
        XCTAssertFalse(store.isEquipped(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)

        store.evaluate(steps: 8_000)
        XCTAssertEqual(store.equip(.coolShades), .coolShades)
        XCTAssertTrue(store.isEquipped(.coolShades))
        XCTAssertEqual(store.equipped[.eyes], .coolShades)
    }

    func testEquipPersistsAcrossReinstantiation() {
        let store = AccessoryStore(defaults: defaults)
        store.evaluate(steps: 8_000)
        store.equip(.coolShades)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertTrue(reloaded.isEquipped(.coolShades))
        XCTAssertEqual(reloaded.equipped[.eyes], .coolShades)
    }

    func testUnequipClearsSlot() {
        let store = AccessoryStore(defaults: defaults)
        store.evaluate(steps: 8_000)
        store.equip(.coolShades)
        store.unequip(.coolShades)
        XCTAssertFalse(store.isEquipped(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)
    }

    func testDifferentSlotsEquipIndependently() {
        let store = AccessoryStore(defaults: defaults)
        store.evaluate(steps: 12_000) // unlocks both coolShades (8k) and babyMochi (12k)

        store.equip(.coolShades)
        store.equip(.babyMochi)

        XCTAssertTrue(store.isEquipped(.coolShades))
        XCTAssertTrue(store.isEquipped(.babyMochi))
        XCTAssertEqual(store.equipped[.eyes], .coolShades)
        XCTAssertEqual(store.equipped[.pet], .babyMochi)

        // Unequipping one slot leaves the other intact.
        store.unequip(.coolShades)
        XCTAssertFalse(store.isEquipped(.coolShades))
        XCTAssertTrue(store.isEquipped(.babyMochi))
        XCTAssertEqual(store.equipped[.pet], .babyMochi)
    }

    func testInitReconcilesStaleEquipped() {
        AccessorySlotStorage.make(.eyes, defaults: defaults).set(.coolShades)

        let store = AccessoryStore(defaults: defaults)
        XCTAssertFalse(store.isEquipped(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)
    }

    #if DEBUG
    func testResetClearsEverything() {
        let store = AccessoryStore(defaults: defaults)
        store.evaluate(steps: 8_000)
        store.equip(.coolShades)

        store.reset()
        XCTAssertFalse(store.isOwned(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertFalse(reloaded.isOwned(.coolShades))
    }
    #endif
}
