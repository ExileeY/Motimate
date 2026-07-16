import Foundation

final class UnavailableStepReader: StepReading {
    func requestPermission() async -> PermissionState {
        .unavailable
    }

    func getSteps(from: Date, to: Date) async -> Int {
        0
    }

    func getTodaySteps() async -> Int {
        0
    }

    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void {
        {}
    }
}
