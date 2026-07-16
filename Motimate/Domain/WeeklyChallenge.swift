import Foundation

enum WeeklyChallenge {
    static func select(weekIndex: Int, owned: Set<AccessoryId>) -> AccessoryId? {
        let itemsPool = Accessory.rotationOrder.filter { !owned.contains($0) }

        if itemsPool.isEmpty { return nil }

        let itemIndex = ((weekIndex % itemsPool.count) + itemsPool.count) % itemsPool.count
        return itemsPool[itemIndex]
    }
}
