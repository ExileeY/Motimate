import Foundation

enum AccessorySlotStorage {
    static func decode(_ value: String?) -> AccessoryId? {
        value.flatMap { AccessoryId(rawValue: $0) }
    }

    static func encode(_ value: AccessoryId?) -> String {
        value?.rawValue ?? ""
    }

    static func normalize(_ value: AccessoryId?) -> AccessoryId? {
        value
    }

    static func make(_ slot: AccessorySlot, defaults: UserDefaults = .standard) -> PersistedStorage<AccessoryId?> {
        PersistedStorage(
            key: "motimate.accessory.\(slot.rawValue).equipped",
            decode: { decode($0) },
            encode: { encode($0) },
            normalize: { normalize($0) },
            fallback: nil,
            defaults: defaults
        )
    }
}
