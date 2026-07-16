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
        XCTAssertEqual(store.progress(.coolShades, steps: 12_500), 0.5, accuracy: 0.0001)
        XCTAssertEqual(store.progress(.coolShades, steps: 25_000), 1, accuracy: 0.0001)
        XCTAssertEqual(store.progress(.coolShades, steps: 60_000), 1, accuracy: 0.0001)
    }

    // MARK: - Unlock

    func testUnlockPersistsAcrossReinstantiation() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertFalse(store.isOwned(.coolShades))

        store.unlock(.coolShades)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertTrue(reloaded.isOwned(.coolShades))
    }

    func testUnlockIsIdempotent() {
        let store = AccessoryStore(defaults: defaults)
        store.unlock(.coolShades)
        store.unlock(.coolShades)
        XCTAssertEqual(store.owned, [.coolShades])
    }

    // MARK: - Equip

    func testEquipRequiresOwnership() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertNil(store.equip(.coolShades)) // not owned → no-op
        XCTAssertFalse(store.isEquipped(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)

        store.unlock(.coolShades)

        XCTAssertEqual(store.equip(.coolShades), .coolShades)
        XCTAssertTrue(store.isEquipped(.coolShades))
        XCTAssertEqual(store.equipped[.eyes], .coolShades)
    }

    func testEquipPersistsAcrossReinstantiation() {
        let store = AccessoryStore(defaults: defaults)
        store.unlock(.coolShades)
        store.equip(.coolShades)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertTrue(reloaded.isEquipped(.coolShades))
        XCTAssertEqual(reloaded.equipped[.eyes], .coolShades)
    }

    func testUnequipClearsSlot() {
        let store = AccessoryStore(defaults: defaults)
        store.unlock(.coolShades)
        store.equip(.coolShades)
        store.unequip(.coolShades)
        XCTAssertFalse(store.isEquipped(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)
    }

    func testDifferentSlotsEquipIndependently() {
        let store = AccessoryStore(defaults: defaults)
        store.unlock(.coolShades)
        store.unlock(.babyMochi)

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

    // MARK: - Equipped list

    func testEquippedListIsEmptyWhenNothingEquipped() {
        let store = AccessoryStore(defaults: defaults)
        XCTAssertEqual(store.equippedList, [])
    }

    func testEquippedListIsOrderedBySlotZOrder() {
        let store = AccessoryStore(defaults: defaults)
        store.unlock(.coolShades)
        store.unlock(.babyMochi)
        store.equip(.coolShades)
        store.equip(.babyMochi)

        XCTAssertEqual(store.equippedList, [.babyMochi, .coolShades])
    }

    func testEquippedListOrderIsStableRegardlessOfEquipSequence() {
        let eyesFirst = AccessoryStore(defaults: defaults)
        eyesFirst.unlock(.coolShades)
        eyesFirst.unlock(.babyMochi)
        eyesFirst.equip(.coolShades)
        eyesFirst.equip(.babyMochi)

        let otherSuite = "AccessoryStoreTests.\(UUID().uuidString)"
        let otherDefaults = UserDefaults(suiteName: otherSuite)!
        defer { otherDefaults.removePersistentDomain(forName: otherSuite) }

        let petFirst = AccessoryStore(defaults: otherDefaults)
        petFirst.unlock(.coolShades)
        petFirst.unlock(.babyMochi)
        petFirst.equip(.babyMochi)
        petFirst.equip(.coolShades)

        XCTAssertEqual(eyesFirst.equippedList, petFirst.equippedList)
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
        store.unlock(.coolShades)
        store.equip(.coolShades)

        store.reset()
        XCTAssertFalse(store.isOwned(.coolShades))
        XCTAssertTrue(store.equipped.isEmpty)

        let reloaded = AccessoryStore(defaults: defaults)
        XCTAssertFalse(reloaded.isOwned(.coolShades))
    }
    #endif
}
