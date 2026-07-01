import XCTest
import CoreGraphics
@testable import Motimate

final class PetStageMotionTests: XCTestCase {
    func testStageAndPetSizingAtReferenceHeight() {
        XCTAssertEqual(PetStageMotion.stageSize(screenHeight: 812), 236)
        XCTAssertEqual(PetStageMotion.petSize(screenHeight: 812), 180)
    }

    func testStageAndPetSizingClampOnVeryShortScreens() {
        XCTAssertEqual(PetStageMotion.stageSize(screenHeight: 400), 201)
        XCTAssertEqual(PetStageMotion.petSize(screenHeight: 400), 153)
    }

    func testStageAndPetSizingClampOnVeryTallScreens() {
        XCTAssertEqual(PetStageMotion.stageSize(screenHeight: 2_000), 271)
        XCTAssertEqual(PetStageMotion.petSize(screenHeight: 2_000), 207)
    }

    func testEnergeticBreathAndBobble() {
        let values = PetStageMotion.values(
            mood: .energetic,
            breathProgress: 1,
            motionProgress: 0.5,
            trembleProgress: 1
        )

        XCTAssertEqual(values.scale, 1.035, accuracy: 0.0001)
        XCTAssertEqual(values.offset.width, 0, accuracy: 0.0001)
        XCTAssertEqual(values.offset.height, -4.5, accuracy: 0.0001)
        XCTAssertEqual(values.rotationDegrees, 0, accuracy: 0.0001)
    }

    func testCalmSwayEndpoints() {
        let start = PetStageMotion.values(
            mood: .calm,
            breathProgress: 0,
            motionProgress: 0,
            trembleProgress: 0
        )
        let end = PetStageMotion.values(
            mood: .calm,
            breathProgress: 0,
            motionProgress: 1,
            trembleProgress: 0
        )

        XCTAssertEqual(start.rotationDegrees, -2.6, accuracy: 0.0001)
        XCTAssertEqual(end.rotationDegrees, 2.6, accuracy: 0.0001)
        XCTAssertEqual(start.offset, .zero)
        XCTAssertEqual(end.offset, .zero)
    }

    func testTiredIgnoresMotionAndQuiverButKeepsTilt() {
        let values = PetStageMotion.values(
            mood: .tired,
            breathProgress: 1,
            motionProgress: 1,
            trembleProgress: 1
        )

        XCTAssertEqual(values.scale, 1.035, accuracy: 0.0001)
        XCTAssertEqual(values.offset, .zero)
        XCTAssertEqual(values.rotationDegrees, -3, accuracy: 0.0001)
    }

    func testSadCombinesBobbleQuiverShiftAndQuiverRotation() {
        let values = PetStageMotion.values(
            mood: .sad,
            breathProgress: 0.5,
            motionProgress: 1,
            trembleProgress: 0.25
        )

        XCTAssertEqual(values.scale, 1.0175, accuracy: 0.0001)
        XCTAssertEqual(values.offset.width, -0.25, accuracy: 0.0001)
        XCTAssertEqual(values.offset.height, -9, accuracy: 0.0001)
        XCTAssertEqual(values.rotationDegrees, -0.2, accuracy: 0.0001)
    }

    func testDurationsMatchReactNativePetStage() {
        XCTAssertEqual(PetStageMotion.breathDurationMs(for: .energetic), 3_300)
        XCTAssertEqual(PetStageMotion.breathDurationMs(for: .calm), 4_500)
        XCTAssertEqual(PetStageMotion.breathDurationMs(for: .tired), 5_500)
        XCTAssertEqual(PetStageMotion.breathDurationMs(for: .sad), 3_600)

        XCTAssertEqual(PetStageMotion.motionDurationMs(for: .energetic), 3_300)
        XCTAssertEqual(PetStageMotion.motionDurationMs(for: .calm), 5_500)
        XCTAssertEqual(PetStageMotion.motionDurationMs(for: .tired), 5_500)
        XCTAssertEqual(PetStageMotion.motionDurationMs(for: .sad), 4_600)
        XCTAssertEqual(PetStageMotion.quiverDurationMs, 360)
    }
}
