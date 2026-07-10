import SwiftUI

struct Confetti: View {
    let onFinished: () -> Void

    var body: some View {
        GeometryReader { geo in
            ConfettiPieces(
                area: geo.size,
                onFinished: onFinished
            )
        }
        .allowsHitTesting(false)
    }
}

private let confettiPalette: [Color] = [
    Color(hex: "#F4A38C"),
    Color(hex: "#F6C07A"),
    Color(hex: "#E0A95C"),
    Color(hex: "#8FBF7F"),
    Color(hex: "#7FA3C9"),
    Color(hex: "#C77E45"),
]

private struct ConfettiPieceSpec: Identifiable {
    let id: Int
    let baseX: CGFloat
    let size: CGFloat
    let color: Color
    let fallStart: CGFloat
    let fallDuration: CGFloat
    let swayAmp: CGFloat
    let swayPhase: CGFloat
    let swayCycles: CGFloat
    let spinTurns: CGFloat
    let spinStart: CGFloat
}

private struct ConfettiPieces: View {
    let area: CGSize
    let onFinished: () -> Void

    // Randomized once and held in @State so the pieces survive HomeView re-renders.
    @State private var specs: [ConfettiPieceSpec]

    init(area: CGSize, onFinished: @escaping () -> Void) {
        self.area = area
        self.onFinished = onFinished
        _specs = State(initialValue: ConfettiPieces.makeSpecs(area: area))
    }

    var body: some View {
        OnceLoop(
            durationMs: ConfettiMath.durationMs,
            onFinished: onFinished
        ) { progress in
            let progress = CGFloat(progress)

            ZStack {
                ForEach(specs) { spec in
                    piece(spec, progress: progress)
                }
            }
            .frame(width: area.width, height: area.height)
        }
    }

    @ViewBuilder
    private func piece(_ spec: ConfettiPieceSpec, progress: CGFloat) -> some View {
        let pieceProgress = ConfettiMath.pieceProgress(
            progress: progress,
            fallStart: spec.fallStart,
            fallDuration: spec.fallDuration
        )
        let placement = ConfettiMath.placement(
            progress: pieceProgress,
            baseX: spec.baseX,
            areaHeight: area.height,
            pieceSize: spec.size,
            swayAmp: spec.swayAmp,
            swayPhase: spec.swayPhase,
            swayCycles: spec.swayCycles
        )
        let angle = Angle.degrees(Double((spec.spinStart + pieceProgress * spec.spinTurns) * 360))

        RoundedRectangle(cornerRadius: spec.size * 0.28)
            .fill(spec.color)
            .frame(width: spec.size, height: spec.size * 0.6)
            .rotationEffect(angle)
            .opacity(placement.opacity)
            .position(placement.position)
    }

    private static func makeSpecs(area: CGSize) -> [ConfettiPieceSpec] {
        let width = max(area.width, 1)

        return (0..<ConfettiMath.pieceCount).map { index in
            let size = CGFloat.random(in: 8...14)
            let fallStart = CGFloat.random(in: 0...0.4)
            let fallDuration = CGFloat.random(in: 0.5...0.75)

            return ConfettiPieceSpec(
                id: index,
                baseX: CGFloat.random(in: 0...width),
                size: size,
                color: confettiPalette.randomElement()!,
                fallStart: fallStart,
                fallDuration: min(fallDuration, 1 - fallStart),
                swayAmp: CGFloat.random(in: 12...34),
                swayPhase: CGFloat.random(in: 0...(2 * .pi)),
                swayCycles: CGFloat.random(in: 1...2.5),
                spinTurns: CGFloat.random(in: 1...3),
                spinStart: CGFloat.random(in: 0...1)
            )
        }
    }
}

#if DEBUG
#Preview("Confetti") {
    ZStack {
        screenBackground[.calm]!.colors[1].ignoresSafeArea()
        Confetti(onFinished: {})
    }
}
#endif
