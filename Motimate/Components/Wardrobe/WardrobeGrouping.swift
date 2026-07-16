import Foundation

enum WardrobeGrouping {
    static func accessoryIds(in slot: AccessorySlot) -> [AccessoryId] {
        AccessoryId.allCases.filter { Accessory.define($0).slot == slot }
    }

    static func ownedAccessoryIds(
        in slot: AccessorySlot,
        owned: Set<AccessoryId>
    ) -> [AccessoryId] {
        accessoryIds(in: slot).filter { owned.contains($0) }
    }

    static func populatedSlots() -> [AccessorySlot] {
        AccessorySlot.allCases.filter { !accessoryIds(in: $0).isEmpty }
    }

    static func ownedStatusString(owned: Int, total: Int) -> String {
        "\(owned) / \(total)"
    }
}
