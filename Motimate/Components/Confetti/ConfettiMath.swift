import Foundation

struct ConfettiPlacement: Equatable {
    let position: CGPoint
    let opacity: CGFloat
}

enum ConfettiMath {
    static let pieceCount = 90
    static let durationMs: Double = 3_200

    static func pieceProgress(
        progress: CGFloat,
        fallStart: CGFloat,
        fallDuration: CGFloat
    ) -> CGFloat {
        guard fallDuration > 0 else { return progress >= fallStart ? 1 : 0 }
        return MathUtils.clamp01((progress - fallStart) / fallDuration)
    }

    static func placement(
        progress: CGFloat,
        baseX: CGFloat,
        areaHeight: CGFloat,
        pieceSize: CGFloat,
        swayAmp: CGFloat,
        swayPhase: CGFloat,
        swayCycles: CGFloat,
        fadeOutStart: CGFloat = 0.75
    ) -> ConfettiPlacement {
        let clamped = MathUtils.clamp01(progress)

        let y = MathUtils.linearInterpolate(-pieceSize, areaHeight + pieceSize, clamped)
        let x = baseX + swayAmp * sin(swayPhase + clamped * swayCycles * 2 * .pi)

        let opacity: CGFloat = clamped <= fadeOutStart
            ? 1
            : MathUtils.clamp01(1 - (clamped - fadeOutStart) / (1 - fadeOutStart))

        return ConfettiPlacement(
            position: CGPoint(x: x, y: y),
            opacity: opacity
        )
    }
}
