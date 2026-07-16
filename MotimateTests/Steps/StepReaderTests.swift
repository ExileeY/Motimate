import XCTest
@testable import Motimate

/// Step source adapter tests. CMPedometer can't be exercised on the Simulator,
/// so these cover the `UnavailableStepReader` contract, `startOfToday`, and
/// protocol conformance.
final class StepReaderTests: XCTestCase {
    func testUnavailableReaderReportsUnavailable() async {
        let reader = UnavailableStepReader()
        let state = await reader.requestPermission()
        XCTAssertEqual(state, .unavailable)
    }

    func testUnavailableReaderReturnsZeroSteps() async {
        let reader = UnavailableStepReader()
        let steps = await reader.getTodaySteps()
        XCTAssertEqual(steps, 0)
    }

    func testUnavailableReaderSubscribeIsNoOp() {
        let reader = UnavailableStepReader()
        var received = false
        let cancel = reader.subscribe { _ in received = true }
        cancel() // callable, and never fired onSteps
        XCTAssertFalse(received)
    }

    func testStartOfTodayIsLocalMidnight() {
        let start = startOfToday()
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: start)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
        XCTAssertTrue(Calendar.current.isDateInToday(start))
    }

    func testStartOfTodayUsesThePassedInstant() {
        let calendar = Calendar.current
        let lateSunday = calendar.date(
            from: DateComponents(year: 2026, month: 3, day: 8, hour: 23, minute: 59, second: 59)
        )!
        XCTAssertEqual(startOfToday(lateSunday), calendar.startOfDay(for: lateSunday))
    }

    func testReadersConformToStepReading() {
        let real: StepReading = StepReader()
        let fallback: StepReading = UnavailableStepReader()
        XCTAssertNotNil(real)
        XCTAssertNotNil(fallback)
    }
}
