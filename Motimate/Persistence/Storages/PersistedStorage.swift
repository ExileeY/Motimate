import Foundation

struct PersistedStorage<T> {
    let key: String
    let decode: (String?) -> T
    let encode: (T) -> String
    let normalize: (T) -> T
    let fallback: T
    var defaults: UserDefaults = .standard

    func get() -> T {
        normalize(decode(defaults.string(forKey: key)))
    }

    func set(_ value: T) {
        defaults.set(encode(normalize(value)), forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
