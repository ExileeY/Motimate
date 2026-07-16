import Foundation

enum NumberFormat {
    private static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    static func grouped(_ value: Int) -> String {
        decimal.string(from: NSNumber(value: value)) ?? String(value)
    }
}
