import Foundation

enum WardrobeGrouping {
    static func accessoryIds(in slot: AccessorySlot) -> [AccessoryId] {
        AccessoryId.allCases.filter { Accessory.define($0).slot == slot }
    }

    static func populatedSlots() -> [AccessorySlot] {
        AccessorySlot.allCases.filter { !accessoryIds(in: $0).isEmpty }
    }

    static func ownedStatusString(owned: Int, total: Int) -> String {
        "\(owned) / \(total)"
    }
}
