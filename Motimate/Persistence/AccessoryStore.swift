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

        let owned = Set(AccessoryId.allCases.filter { stores[$0]!.get() })
        self.owned = owned

        // Hydrate each slot, reconciling a stale id that isn't owned or whose definition's
        // slot no longer matches this slot (guards against a hand-written/orphaned key).
        var equipped: [AccessorySlot: AccessoryId] = [:]
        for slot in AccessorySlot.allCases {
            let store = slotStores[slot]!
            guard let id = store.get() else { continue }
            if owned.contains(id), Accessory.define(id).slot == slot {
                equipped[slot] = id
            } else {
                store.set(nil)
            }
        }
        self.equipped = equipped
    }

    /// Fraction toward earning the accessory today (0...1), independent of the user's
    /// step goal. Do **not** reuse `DailyStepsModel.progress` — that is goal-relative.
    func progress(_ id: AccessoryId, steps: Int) -> Double {
        let goal = Accessory.define(id).stepGoal
        guard goal > 0 else { return 1 }
        return MathUtils.clamp01(Double(steps) / Double(goal))
    }

    func isOwned(_ id: AccessoryId) -> Bool {
        owned.contains(id)
    }

    /// The accessories currently worn, one per filled slot — for rendering on the pet.
    var equippedList: [AccessoryId] {
        Array(equipped.values)
    }

    /// Whether this specific accessory is the one worn in its slot.
    func isEquipped(_ id: AccessoryId) -> Bool {
        equipped[Accessory.define(id).slot] == id
    }

    /// Permanently unlocks any not-yet-owned accessory whose goal `steps` meets.
    /// Idempotent and cheap — safe to call on every step change. Returns the ids newly
    /// unlocked by this call (empty when nothing changed).
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

    /// Equips an owned accessory into its slot, replacing whatever was worn there.
    /// Equipping an unowned accessory is a no-op. Returns the id now worn in that slot.
    @discardableResult
    func equip(_ id: AccessoryId) -> AccessoryId? {
        let slot = Accessory.define(id).slot
        guard owned.contains(id) else { return equipped[slot] }
        equipped[slot] = id
        equippedStores[slot]!.set(id)
        return id
    }

    /// Removes `id` from its slot if it is the one currently worn there; otherwise a no-op.
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
