import CoreMotion
import Foundation

/// `CMPedometer`-backed step source. The direct equivalent of the expo-sensors
/// `Pedometer` used by the RN app.
///
/// `startUpdates(from:)` already yields cumulative `numberOfSteps` from the
/// start date, so the RN `baseline + delta` bookkeeping collapses to reading
/// `data.numberOfSteps` directly.
///
/// Failure is never thrown — `requestPermission` resolves to a `PermissionState`
/// and the read paths degrade to `0`, mirroring the RN adapter.
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

    func getTodaySteps() async -> Int {
        await withCheckedContinuation { continuation in
            pedometer.queryPedometerData(from: startOfToday(), to: Date()) { data, _ in
                continuation.resume(returning: data.map { Int(truncating: $0.numberOfSteps) } ?? 0)
            }
        }
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
