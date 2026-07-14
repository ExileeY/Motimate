import Foundation

final class AccessoryStore: ObservableObject {
    @Published private(set) var owned: Set<AccessoryId>
    @Published private(set) var equipped: [AccessorySlot: AccessoryId]

    private let ownedStores: [AccessoryId: PersistedStorage<Bool>]
    private let equippedStores: [AccessorySlot: PersistedStorage<AccessoryId?>]

    init(defaults: UserDefaults = .standard) {
        var stores: [AccessoryId: PersistedStorage<Bool>] = [:]
        for id in AccessoryId.allCases {
            stores[id] = AccessoryOwnedStorage.make(
                id,
                defaults: defaults
            )
        }
        ownedStores = stores

        var slotStores: [AccessorySlot: PersistedStorage<AccessoryId?>] = [:]
        for slot in AccessorySlot.allCases {
            slotStores[slot] = AccessorySlotStorage.make(
                slot,
                defaults: defaults
            )
        }
        equippedStores = slotStores

        let owned = Self.initOwned(stores)
        self.owned = owned
        self.equipped = Self.initEquipped(slotStores, owned: owned)
    }

    private static func initOwned(
        _ stores: [AccessoryId: PersistedStorage<Bool>]
    ) -> Set<AccessoryId> {
        Set(AccessoryId.allCases.filter { stores[$0]!.get() })
    }

    private static func initEquipped(
        _ stores: [AccessorySlot: PersistedStorage<AccessoryId?>],
        owned: Set<AccessoryId>
    ) -> [AccessorySlot: AccessoryId] {
        var equipped: [AccessorySlot: AccessoryId] = [:]
        for slot in AccessorySlot.allCases {
            let store = stores[slot]!
            guard let id = store.get() else { continue }
            if owned.contains(id), Accessory.define(id).slot == slot {
                equipped[slot] = id
            } else {
                store.set(nil)
            }
        }
        return equipped
    }

    func progress(_ id: AccessoryId, steps: Int) -> Double {
        let accessoryGoal = Accessory.define(id).stepGoal
        guard accessoryGoal > 0 else { return 1 }
        return MathUtils.clamp01(Double(steps) / Double(accessoryGoal))
    }

    var equippedList: [AccessoryId] {
        Array(equipped.values)
    }

    func isOwned(_ id: AccessoryId) -> Bool {
        owned.contains(id)
    }

    func isEquipped(_ id: AccessoryId) -> Bool {
        equipped[Accessory.define(id).slot] == id
    }

    /// Permanently unlocks any not-yet-owned accessory whose goal `steps` meets.
    @discardableResult
    func evaluate(steps: Int) -> [AccessoryId] {
        var newly: [AccessoryId] = []
        for id in AccessoryId.allCases where !owned.contains(id) {
            if steps >= Accessory.define(id).stepGoal {
                unlock(id)
                newly.append(id)
            }
        }
        return newly
    }

    @discardableResult
    func equip(_ id: AccessoryId) -> AccessoryId? {
        let slot = Accessory.define(id).slot
        guard owned.contains(id) else { return equipped[slot] }
        equipped[slot] = id
        equippedStores[slot]!.set(id)
        return id
    }

    func unequip(_ id: AccessoryId) {
        let slot = Accessory.define(id).slot
        guard equipped[slot] == id else { return }
        equipped[slot] = nil
        equippedStores[slot]!.set(nil)
    }

    private func unlock(_ id: AccessoryId) {
        guard !owned.contains(id) else { return }
        owned.insert(id)
        ownedStores[id]!.set(true)
    }

    #if DEBUG
    func reset() {
        for id in AccessoryId.allCases {
            ownedStores[id]!.clear()
        }
        for slot in AccessorySlot.allCases {
            equippedStores[slot]!.clear()
        }
        owned = []
        equipped = [:]
    }
    #endif
}
