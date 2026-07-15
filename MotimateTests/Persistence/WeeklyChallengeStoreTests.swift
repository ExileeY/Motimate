import XCTest
@testable import Motimate

final class WeeklyChallengeStoreTests: XCTestCase {
    private var suiteName = ""
    private var defaults: UserDefaults!

    private let monday = WeeklyChallengeStoreTests.localNoon(2026, 7, 13)
    private let wednesday = WeeklyChallengeStoreTests.localNoon(2026, 7, 15)
    private let sunday = WeeklyChallengeStoreTests.localNoon(2026, 7, 19)
    private let nextMonday = WeeklyChallengeStoreTests.localNoon(2026, 7, 20)

    private static func localNoon(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return Calendar.current.date(from: components)!
    }

    override func setUp() {
        super.setUp()
        suiteName = "WeeklyChallengeStoreTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    // MARK: - Week index

    func testFirstEverCallSeedsOriginAtIndexZero() {
        let store = WeeklyChallengeStore(defaults: defaults)
        XCTAssertEqual(store.weekIndex(on: wednesday), 0)
    }

    func testIndexIsStableAcrossTheWholeWeek() {
        let store = WeeklyChallengeStore(defaults: defaults)
        XCTAssertEqual(store.weekIndex(on: monday), 0)
        XCTAssertEqual(store.weekIndex(on: wednesday), 0)
        XCTAssertEqual(store.weekIndex(on: sunday), 0)
    }

    func testIndexAdvancesOnMonday() {
        let store = WeeklyChallengeStore(defaults: defaults)

        XCTAssertEqual(store.weekIndex(on: monday), 0)
        XCTAssertEqual(store.weekIndex(on: nextMonday), 1)
    }

    func testOriginPersistsAcrossReinstantiation() {
        let store = WeeklyChallengeStore(defaults: defaults)
        _ = store.weekIndex(on: monday) // seeds origin at this week

        let reloaded = WeeklyChallengeStore(defaults: defaults)
        XCTAssertEqual(reloaded.weekIndex(on: nextMonday), 1)
    }

    // MARK: - Freeze

    func testSameItemAllWeek() {
        let store = WeeklyChallengeStore(defaults: defaults)
        let mondayPick = store.resolve(owned: [], on: monday)

        XCTAssertNotNil(mondayPick)
        XCTAssertEqual(store.resolve(owned: [], on: wednesday), mondayPick)
        XCTAssertEqual(store.resolve(owned: [], on: sunday), mondayPick)
    }

    func testEarningMidWeekDoesNotSwapTheItem() {
        let store = WeeklyChallengeStore(defaults: defaults)
        let pick = store.resolve(owned: [], on: monday)!

        let ownedAfterEarning: Set<AccessoryId> = [pick]
        XCTAssertEqual(store.resolve(owned: ownedAfterEarning, on: wednesday), pick)
        XCTAssertEqual(store.resolve(owned: ownedAfterEarning, on: sunday), pick)
    }

    func testRotatesOnTheNextMonday() {
        let store = WeeklyChallengeStore(defaults: defaults)

        let item = store.resolve(owned: [], on: monday)!
        let next = store.resolve(owned: [item], on: nextMonday)

        XCTAssertNotNil(next)
        XCTAssertNotEqual(next, item)
    }

    func testFrozenPickSurvivesReinstantiation() {
        let store = WeeklyChallengeStore(defaults: defaults)
        let pick = store.resolve(owned: [], on: monday)

        let reloaded = WeeklyChallengeStore(defaults: defaults)
        XCTAssertEqual(reloaded.resolve(owned: [], on: sunday), pick)
    }

    // MARK: - Placeholder

    func testAllOwnedResolvesToNil() {
        let store = WeeklyChallengeStore(defaults: defaults)
        XCTAssertNil(store.resolve(owned: Set(AccessoryId.allCases), on: monday))
    }

    func testPlaceholderReEvaluatesSoNewContentIsPickedUpMidWeek() {
        let store = WeeklyChallengeStore(defaults: defaults)
        XCTAssertNil(store.resolve(owned: Set(AccessoryId.allCases), on: monday))
        XCTAssertNotNil(store.resolve(owned: [], on: wednesday))
    }

    #if DEBUG
    func testDebugAdvanceMovesToTheNextWeek() {
        let store = WeeklyChallengeStore(defaults: defaults)
        XCTAssertEqual(store.weekIndex(on: wednesday), 0)

        store.debugAdvance(weeks: 1, on: wednesday)
        XCTAssertEqual(store.weekIndex(on: wednesday), 1)

        store.debugAdvance(weeks: 1, on: wednesday)
        XCTAssertEqual(store.weekIndex(on: wednesday), 2)
    }

    func testDebugAdvanceRotatesTheItem() {
        let store = WeeklyChallengeStore(defaults: defaults)
        let item = store.resolve(owned: [], on: wednesday)!

        store.debugAdvance(weeks: 1, on: wednesday)
        let next = store.resolve(owned: [item], on: wednesday)

        XCTAssertNotEqual(next, item)
    }

    func testResetClearsEverything() {
        let store = WeeklyChallengeStore(defaults: defaults)
        _ = store.resolve(owned: [], on: monday)
        store.debugAdvance(weeks: 3, on: monday)

        store.reset()
        XCTAssertEqual(store.weekIndex(on: monday), 0)
    }
    #endif
}
