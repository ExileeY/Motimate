import CoreMotion
import Foundation

final class StepReader: StepReading {
    private let pedometer = CMPedometer()

    func requestPermission() async -> PermissionState {
        guard CMPedometer.isStepCountingAvailable() else { return .unavailable }

        // A one-shot query forces the OS motion prompt; granted/denied is
        // inferred from success vs. the not-authorized error.
        return await withCheckedContinuation { continuation in
            pedometer.queryPedometerData(from: startOfToday(), to: Date()) { _, error in
                if let error = error as NSError?,
                    error.domain == CMErrorDomain,
                    error.code == CMErrorMotionActivityNotAuthorized.rawValue
                        || error.code == CMErrorMotionActivityNotEntitled.rawValue
                {
                    continuation.resume(returning: .denied)
                } else if error != nil {
                    continuation.resume(returning: .denied)
                } else {
                    continuation.resume(returning: .granted)
                }
            }
        }
    }

    func getSteps(from: Date, to: Date) async -> Int {
        await withCheckedContinuation { continuation in
            pedometer.queryPedometerData(from: from, to: to) { data, _ in
                continuation.resume(returning: data.map { Int(truncating: $0.numberOfSteps) } ?? 0)
            }
        }
    }

    func getTodaySteps() async -> Int {
        await getSteps(from: startOfToday(), to: Date())
    }

    func subscribe(onSteps: @escaping (Int) -> Void) -> () -> Void {
        var cancelled = false

        pedometer.startUpdates(from: startOfToday()) { data, _ in
            guard !cancelled, let data else { return }
            let steps = Int(truncating: data.numberOfSteps)
            DispatchQueue.main.async {
                guard !cancelled else { return }
                onSteps(steps)
            }
        }

        return { [weak self] in
            cancelled = true
            self?.pedometer.stopUpdates()
        }
    }
}
