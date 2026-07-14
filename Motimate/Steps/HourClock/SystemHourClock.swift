import Foundation

final class SystemHourClock: HourClock {
    private(set) var hour: Int
    private var onHour: ((Int) -> Void)?
    private var timer: Timer?

    init() {
        hour = Calendar.current.component(.hour, from: Date())
    }

    func subscribe(onHour: @escaping (Int) -> Void) -> () -> Void {
        self.onHour = onHour
        startTimer()

        return { [weak self] in
            guard let self else { return }
            self.timer?.invalidate()
            self.timer = nil
            self.onHour = nil
        }
    }

    func refresh() {
        handleEmit(Calendar.current.component(.hour, from: Date()))
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.handleEmit(Calendar.current.component(.hour, from: Date()))
        }
    }

    private func handleEmit(_ next: Int) {
        guard next != hour else { return }
        hour = next
        onHour?(next)
    }

    deinit {
        timer?.invalidate()
    }
}
