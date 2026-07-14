import XCTest
@testable import Motimate

final class MovementCardTests: XCTestCase {
    private let message = MessageSet(
        headline: "Walk with me?",
        subtitle: "A little motion helps.",
        meta: "quiet so far",
        footer: "Tiny steps still count."
    )

    func testMovementMetaUsesLocalizedStepCountWhenLive() {
        XCTAssertEqual(
            movementMeta(
                message: message,
                steps: 1_234,
                hasLiveSteps: true,
                locale: Locale(identifier: "en_US")
            ),
            "1,234 steps"
        )
    }

    func testMovementMetaUsesMessageMetaWithoutLiveSteps() {
        XCTAssertEqual(
            movementMeta(
                message: message,
                steps: 1_234,
                hasLiveSteps: false,
                locale: Locale(identifier: "en_US")
            ),
            "quiet so far"
        )
    }

    func testProgressFillFractionClampsBelowZero() {
        XCTAssertEqual(progressFillFraction(-0.2), 0)
    }

    func testProgressFillFractionClampsAboveOne() {
        XCTAssertEqual(progressFillFraction(1.5), 1)
    }

    func testProgressFillFractionRoundsToWholePercent() {
        XCTAssertEqual(progressFillFraction(0.424), 0.42, accuracy: 0.0001)
        XCTAssertEqual(progressFillFraction(0.425), 0.43, accuracy: 0.0001)
    }
}
