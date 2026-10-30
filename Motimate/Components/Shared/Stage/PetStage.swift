import SwiftUI

struct PetStageMotionValues: Equatable {
    let scale: CGFloat
    let offset: CGSize
    let rotationDegrees: Double
}

struct PetGroundShadowValues: Equatable {
    let scale: CGFloat
    let opacity: Double
}

enum PetStageMotion {
    static let quiverDurationMs: Double = 1_000

    private static let breatheDepth: CGFloat = 0.035
    private static let bobbleRise: CGFloat = 9
    private static let swayDegrees: Double = 2.6
    private static let tiredTiltDegrees: Double = -3
    private static let quiverPixels: CGFloat = 0.35
    private static let quiverDegrees: Double = 0.3
    private static let shadowLiftShrink: CGFloat = 0.2
    private static let shadowLiftFade: Double = 0.4

    static func breathDurationMs(for mood: Mood) -> Double {
        switch mood {
        case .energetic:
            return 3_300
        case .calm:
            return 4_500
        case .tired:
            return 5_500
        case .sad:
            return 3_600
        }
    }

    static func motionDurationMs(for mood: Mood) -> Double {
        switch mood {
        case .energetic:
            return 3_300
        case .calm:
            return 5_500
        case .tired:
            return 5_500
        case .sad:
            return 4_600
        }
    }

    static func stageSize(screenHeight: CGFloat, sizeMultiplier: CGFloat = 1) -> CGFloat {
        (BOX_SIZE * computeScale(screenHeight) * sizeMultiplier).rounded()
    }

    static func petSize(screenHeight: CGFloat, sizeMultiplier: CGFloat = 1) -> CGFloat {
        (PET_SIZE * computeScale(screenHeight) * sizeMultiplier).rounded()
    }

    /// How far the pet's feet sit below the stage center.
    static func footOffset(screenHeight: CGFloat, sizeMultiplier: CGFloat = 1) -> CGFloat {
        petSize(screenHeight: screenHeight, sizeMultiplier: sizeMultiplier) * PET_FOOT_OFFSET
    }

    /// The contact shadow shrinks and fades as the pet bobs up off the ground.
    static func groundShadow(lift: CGFloat) -> PetGroundShadowValues {
        let t = MathUtils.clamp01(lift / bobbleRise)
        return PetGroundShadowValues(
            scale: 1 - shadowLiftShrink * t,
            opacity: 1 - shadowLiftFade * Double(t)
        )
    }

    static func values(
        mood: Mood,
        breathProgress: CGFloat,
        motionProgress: CGFloat,
        trembleProgress: CGFloat
    ) -> PetStageMotionValues {
        var offset = CGSize.zero
        var rotationDegrees = 0.0

        switch mood {
        case .energetic:
            offset.height = -bobbleRise * motionProgress
        case .calm:
            rotationDegrees = -swayDegrees + 2 * swayDegrees * Double(motionProgress)
        case .tired:
            rotationDegrees = tiredTiltDegrees
        case .sad:
            offset.width = -quiverPixels + 2 * quiverPixels * trembleProgress
            offset.height = -bobbleRise * motionProgress
            rotationDegrees = -quiverDegrees + 2 * quiverDegrees * Double(trembleProgress)
        }

        return PetStageMotionValues(
            scale: 1 + breatheDepth * breathProgress,
            offset: offset,
            rotationDegrees: rotationDegrees
        )
    }
}

struct PetStage: View {
    let mood: Mood
    var petId: PetId = PET_ID_DEFAULT
    var screenHeight: CGFloat = RESPONSIVE_BASE_HEIGHT
    var accessories: [AccessoryId] = []
    var sizeMultiplier: CGFloat = 1
    var groundShadow = false

    var entrance = EntranceMotionParams()

    var body: some View {
        let stage = PetStageMotion.stageSize(
            screenHeight: screenHeight,
            sizeMultiplier: sizeMultiplier
        )
        let pet = PetStageMotion.petSize(
            screenHeight: screenHeight,
            sizeMultiplier: sizeMultiplier
        )
        let definition = petDefinition(petId)

        PetStageMotionScope(mood: mood) { values in
            ZStack {
                Glow(
                    mood: mood,
                    size: stage
                )
                .petStageMotion(values)

                if groundShadow {
                    PetGroundShadow(
                        petSize: pet,
                        footOffset: PetStageMotion.footOffset(
                            screenHeight: screenHeight,
                            sizeMultiplier: sizeMultiplier
                        ),
                        values: PetStageMotion.groundShadow(lift: -values.offset.height)
                    )
                }

                EntranceMotion(params: entrance) {
                    ZStack {
                        definition.body(
                            mood,
                            pet
                        )

                        ForEach(accessories, id: \.self) { accessory in
                            AccessoryOverlay(
                                accessory: accessory,
                                petId: petId,
                                mood: mood,
                                petSize: pet
                            )
                        }
                    }
                    .compositingGroup()
                }
                .petStageMotion(values)
            }
            .frame(width: stage, height: stage)
        }
        .frame(width: stage, height: stage)
    }
}

private struct PetGroundShadow: View {
    private static let color = Color.black.opacity(0.16)
    private static let widthRatio: CGFloat = 0.55     // of pet size
    private static let aspect: CGFloat = 0.16         // height / width

    let petSize: CGFloat
    let footOffset: CGFloat
    let values: PetGroundShadowValues

    var body: some View {
        let width = petSize * Self.widthRatio

        Ellipse()
            .fill(Self.color)
            .frame(width: width, height: width * Self.aspect)
            .blur(radius: 2.5)
            .scaleEffect(values.scale)
            .opacity(values.opacity)
            .offset(y: footOffset)
            .allowsHitTesting(false)
    }
}

private extension View {
    func petStageMotion(_ values: PetStageMotionValues) -> some View {
        scaleEffect(values.scale)
            .offset(values.offset)
            .rotationEffect(.degrees(values.rotationDegrees))
    }
}

private struct PetStageMotionScope<Content: View>: View {
    let mood: Mood
    let content: (PetStageMotionValues) -> Content

    @State private var startDate = Date()

    init(
        mood: Mood,
        @ViewBuilder content: @escaping (PetStageMotionValues) -> Content
    ) {
        self.mood = mood
        self.content = content
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            content(motionValues(at: timeline.date))
        }
        .onAppear { startDate = Date() }
    }

    private func motionValues(at date: Date) -> PetStageMotionValues {
        let elapsedMs = date.timeIntervalSince(startDate) * 1_000

        let breathProgress = LoopTiming.progress(
            elapsedMs: elapsedMs,
            durationMs: PetStageMotion.breathDurationMs(for: mood),
            mode: .pingPong
        )
        let motionProgress = LoopTiming.progress(
            elapsedMs: elapsedMs,
            durationMs: PetStageMotion.motionDurationMs(for: mood),
            mode: .pingPong,
            active: mood != .tired
        )
        let trembleProgress = LoopTiming.progress(
            elapsedMs: elapsedMs,
            durationMs: PetStageMotion.quiverDurationMs,
            mode: .pingPong,
            active: mood == .sad
        )

        return PetStageMotion.values(
            mood: mood,
            breathProgress: CGFloat(breathProgress),
            motionProgress: CGFloat(motionProgress),
            trembleProgress: CGFloat(trembleProgress)
        )
    }
}

#if DEBUG
#Preview("PetStage Moods") {
    VStack(spacing: 18) {
        ForEach(Mood.allCases, id: \.self) { mood in
            PetStage(
                mood: mood,
                petId: .mochi
            )
            .background(ThemeTokens.day.screenBackground(mood).colors[1])
        }
    }
    .padding()
}

#Preview("PetStage Registry") {
    HStack(spacing: 18) {
        PetStage(
            mood: .energetic,
            petId: .dog
        )
        .background(ThemeTokens.day.screenBackground(.energetic).colors[1])

        PetStage(
            mood: .sad,
            petId: .tomato
        )
        .background(ThemeTokens.day.screenBackground(.sad).colors[1])
    }
    .padding()
}
#endif
