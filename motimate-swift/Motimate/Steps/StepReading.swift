import Foundation

enum PermissionState: String {
    case granted
    case denied
    case unavailable
}

protocol StepReading {
    func requestPermission() async -> PermissionState
    func getTodaySteps() async -> Int
    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void
}

/// Local midnight — equivalent of RN's `setHours(0, 0, 0, 0)`.
func startOfToday() -> Date {
    Calendar.current.startOfDay(for: Date())
}
