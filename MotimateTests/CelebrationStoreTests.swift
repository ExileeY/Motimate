import XCTest
@testable import Motimate

final class CelebrationStoreTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!

    // Local noon on a fixed day, so +/- a few hours never crosses midnight
    // regardless of the machine's timezone.
    private let today = CelebrationStoreTests.localNoon(year: 2024, month: 6, day: 15)
    private var tomorrow: Date { today.addingTimeInterval(24 * 60 * 60) }

    private static func localNoon(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return Calendar.current.date(from: components)!
    }

    override func setUp() {
        super.setUp()
        suiteName = "CelebrationStoreTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    func testFreshStoreAllowsCelebration() {
        let store = CelebrationStore(defaults: defaults)
        XCTAssertTrue(store.shouldCelebrate(on: today))
    }

    func testMarkingSuppressesSameDayReplay() {
        let store = CelebrationStore(defaults: defaults)
        store.markCelebrated(on: today)
        XCTAssertFalse(store.shouldCelebrate(on: today))
    }

    func testNewDayReAllowsCelebration() {
        let store = CelebrationStore(defaults: defaults)
        store.markCelebrated(on: today)
        XCTAssertTrue(store.shouldCelebrate(on: tomorrow))
    }

    func testRecordPersistsAcrossReinstantiation() {
        let store = CelebrationStore(defaults: defaults)
        store.markCelebrated(on: today)

        let reloaded = CelebrationStore(defaults: defaults)
        XCTAssertFalse(reloaded.shouldCelebrate(on: today))
        XCTAssertTrue(reloaded.shouldCelebrate(on: tomorrow))
    }

    func testResetTodayReAllowsCelebration() {
        let store = CelebrationStore(defaults: defaults)
        store.markCelebrated(on: today)
        XCTAssertFalse(store.shouldCelebrate(on: today))

        store.resetToday()
        XCTAssertTrue(store.shouldCelebrate(on: today))
    }

    func testDayKeyIsLocalCalendarDay() {
        let morning = today.addingTimeInterval(-4 * 60 * 60) // 08:00 local
        let evening = today.addingTimeInterval(8 * 60 * 60)  // 20:00 local
        XCTAssertEqual(CelebrationDateFormatter.key(morning), CelebrationDateFormatter.key(evening))
        XCTAssertNotEqual(CelebrationDateFormatter.key(today), CelebrationDateFormatter.key(tomorrow))
    }
}
