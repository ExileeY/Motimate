import Foundation

enum PermissionState: String {
    case granted
    case denied
    case unavailable
}

protocol StepReading {
    func requestPermission() async -> PermissionState
    func getSteps(from: Date, to: Date) async -> Int
    func getTodaySteps() async -> Int
    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void
}

func startOfToday(_ now: Date = Date()) -> Date {
    Calendar.current.startOfDay(for: now)
}
