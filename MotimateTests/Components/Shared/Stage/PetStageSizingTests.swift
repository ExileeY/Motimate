import XCTest
import CoreGraphics
@testable import Motimate

final class PetStageSizingTests: XCTestCase {
    func testStageAndPetSizingAtReferenceHeight() {
        XCTAssertEqual(
            PetStageMotion.stageSize(screenHeight: 812),
            236
        )
        XCTAssertEqual(
            PetStageMotion.petSize(screenHeight: 812),
            180
        )
    }

    func testStageAndPetSizingClampOnVeryShortScreens() {
        XCTAssertEqual(
            PetStageMotion.stageSize(screenHeight: 400),
            201
        )
        XCTAssertEqual(
            PetStageMotion.petSize(screenHeight: 400),
            153
        )
    }

    func testStageAndPetSizingClampOnVeryTallScreens() {
        XCTAssertEqual(
            PetStageMotion.stageSize(screenHeight: 2_000),
            271
        )
        XCTAssertEqual(
            PetStageMotion.petSize(screenHeight: 2_000),
            207
        )
    }

    func testSizingDefaultsToAnIdentityMultiplier() {
        for height in [CGFloat(400), 812, 2_000] {
            XCTAssertEqual(
                PetStageMotion.stageSize(screenHeight: height),
                PetStageMotion.stageSize(screenHeight: height, sizeMultiplier: 1)
            )
            XCTAssertEqual(
                PetStageMotion.petSize(screenHeight: height),
                PetStageMotion.petSize(screenHeight: height, sizeMultiplier: 1)
            )
        }
    }

    func testStageAndPetSizingApplyMultiplier() {
        XCTAssertEqual(
            PetStageMotion.stageSize(screenHeight: 812, sizeMultiplier: 0.72),
            170
        )
        XCTAssertEqual(
            PetStageMotion.petSize(screenHeight: 812, sizeMultiplier: 0.72),
            130
        )
    }

    func testFootOffsetIsPetSizeTimesFootRatio() {
        XCTAssertEqual(
            PetStageMotion.footOffset(screenHeight: 812),
            PET_SIZE * PET_FOOT_OFFSET,
            accuracy: 0.0001
        )
        XCTAssertEqual(
            PetStageMotion.footOffset(screenHeight: 812, sizeMultiplier: 0.72),
            130 * PET_FOOT_OFFSET,
            accuracy: 0.0001
        )
    }
}
