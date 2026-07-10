import Foundation

enum CelebrationDateFormatter {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func key(_ date: Date = Date()) -> String {
        formatter.string(from: date)
    }
}

final class CelebrationStore: ObservableObject {
    private let store: PersistedStorage<String?>

    init(defaults: UserDefaults = .standard) {
        store = PersistedStorage(
            key: "motimate.celebrated",
            decode: { $0 },
            encode: { $0 ?? "" },
            normalize: { $0 },
            fallback: nil,
            defaults: defaults
        )
    }

    func shouldCelebrate(on date: Date = Date()) -> Bool {
        store.get() != CelebrationDateFormatter.key(date)
    }

    func markCelebrated(on date: Date = Date()) {
        store.set(CelebrationDateFormatter.key(date))
    }

    #if DEBUG
    func resetToday() {
        store.clear()
    }
    #endif
}
