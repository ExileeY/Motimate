import SwiftUI

struct PetStageMotionValues: Equatable {
    let scale: CGFloat
    let offset: CGSize
    let rotationDegrees: Double
}

enum PetStageMotion {
    static let quiverDurationMs: Double = 360

    private static let breatheDepth: CGFloat = 0.035
    private static let bobbleRise: CGFloat = 9
    private static let swayDegrees: Double = 2.6
    private static let tiredTiltDegrees: Double = -3
    private static let quiverPixels: CGFloat = 0.5
    private static let quiverDegrees: Double = 0.4

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

    static func stageSize(screenHeight: CGFloat) -> CGFloat {
        (BOX_SIZE * computeScale(screenHeight)).rounded()
    }

    static func petSize(screenHeight: CGFloat) -> CGFloat {
        (PET_SIZE * computeScale(screenHeight)).rounded()
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

    var body: some View {
        let stage = PetStageMotion.stageSize(screenHeight: screenHeight)
        let pet = PetStageMotion.petSize(screenHeight: screenHeight)
        let definition = petDefinition(petId)

        PetStageMotionScope(mood: mood) {
            ZStack {
                Glow(
                    mood: mood,
                    size: stage
                )

                definition.body(
                    mood,
                    pet
                )
            }
            .frame(width: stage, height: stage)
        }
        .frame(width: stage, height: stage)
    }
}

private struct PetStageMotionScope<Content: View>: View {
    let mood: Mood
    let content: Content

    @State private var breathProgress: CGFloat = 0
    @State private var motionProgress: CGFloat = 0
    @State private var trembleProgress: CGFloat = 0

    init(
        mood: Mood,
        @ViewBuilder content: () -> Content
    ) {
        self.mood = mood
        self.content = content()
    }

    var body: some View {
        let values = PetStageMotion.values(
            mood: mood,
            breathProgress: breathProgress,
            motionProgress: motionProgress,
            trembleProgress: trembleProgress
        )

        content
            .scaleEffect(values.scale)
            .offset(values.offset)
            .rotationEffect(.degrees(values.rotationDegrees))
            .onAppear(perform: restartAnimations)
            .onChange(of: mood) { _ in restartAnimations() }
    }

    private func restartAnimations() {
        resetProgress()
        startBreathAnimation()
        startMotionAnimation()
        startTrembleAnimation()
    }

    private func resetProgress() {
        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            breathProgress = 0
            motionProgress = 0
            trembleProgress = 0
        }
    }

    private func startBreathAnimation() {
        withAnimation(loopAnimation(durationMs: PetStageMotion.breathDurationMs(for: mood))) {
            breathProgress = 1
        }
    }

    private func startMotionAnimation() {
        guard mood != .tired else { return }

        withAnimation(loopAnimation(durationMs: PetStageMotion.motionDurationMs(for: mood))) {
            motionProgress = 1
        }
    }

    private func startTrembleAnimation() {
        guard mood == .sad else { return }

        withAnimation(loopAnimation(durationMs: PetStageMotion.quiverDurationMs)) {
            trembleProgress = 1
        }
    }

    private func loopAnimation(durationMs: Double) -> Animation {
        .easeInOut(duration: durationMs / 2_000)
            .repeatForever(autoreverses: true)
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
            .background(screenBackground[mood]!.colors[1])
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
        .background(screenBackground[.energetic]!.colors[1])

        PetStage(
            mood: .sad,
            petId: .tomato
        )
        .background(screenBackground[.sad]!.colors[1])
    }
    .padding()
}
#endif
