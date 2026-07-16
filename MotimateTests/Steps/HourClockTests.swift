import XCTest
@testable import Motimate

final class FakeHourClock: HourClock {
    private(set) var hour: Int
    private var onHour: ((Int) -> Void)?

    private(set) var subscribeCount = 0
    private(set) var unsubscribeCount = 0

    init(hour: Int) {
        self.hour = hour
    }

    func subscribe(onHour: @escaping (Int) -> Void) -> () -> Void {
        subscribeCount += 1
        self.onHour = onHour

        return { [weak self] in
            self?.unsubscribeCount += 1
            self?.onHour = nil
        }
    }

    func refresh() {}

    func push(_ next: Int) {
        guard next != hour else { return }

        hour = next
        onHour?(next)
    }
}

final class HourClockTests: XCTestCase {
    func testStartsAtCurrentHour() {
        let clock = SystemHourClock()
        XCTAssertEqual(clock.hour, Calendar.current.component(.hour, from: Date()))
    }

    func testRefreshWithNoChangeDoesNotFire() {
        let clock = SystemHourClock()
        var fired = 0
        _ = clock.subscribe { _ in fired += 1 }

        clock.refresh() // same hour — no boundary crossed
        XCTAssertEqual(fired, 0)
    }

    func testFakeEmitsOnlyOnChange() {
        let clock = FakeHourClock(hour: 9)
        var received: [Int] = []
        _ = clock.subscribe { received.append($0) }

        clock.push(9)  // no change
        clock.push(12) // change
        clock.push(12) // no change
        clock.push(13) // change

        XCTAssertEqual(received, [12, 13])
        XCTAssertEqual(clock.hour, 13)
    }

    func testFakeUnsubscribeStopsDelivery() {
        let clock = FakeHourClock(hour: 9)
        var received: [Int] = []
        let unsubscribe = clock.subscribe { received.append($0) }

        clock.push(10)
        unsubscribe()
        clock.push(11)

        XCTAssertEqual(received, [10])
        XCTAssertEqual(clock.unsubscribeCount, 1)
    }
}
