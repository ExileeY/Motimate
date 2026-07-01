import SwiftUI

private enum ParticleMotion {
    static let translateYMin: CGFloat = 10
    static let translateYMax: CGFloat = -40
    static let scaleMin: CGFloat = 0.6
    static let scaleMax: CGFloat = 1
    static let fadeIn: CGFloat = 0.28
}

private struct ParticleSpec: Identifiable {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let radius: CGFloat
    let color: Color
    let durationMs: Double
    let delayMs: Double
}

private let particleSpecs = [
    ParticleSpec(
        id: 0,
        x: BOX_CENTER - 70,
        y: 30,
        radius: 9,
        color: Color(hex: "#F4A38C"),
        durationMs: 3_400,
        delayMs: 0
    ),
    ParticleSpec(
        id: 1,
        x: BOX_CENTER + 70,
        y: 30,
        radius: 9,
        color: Color(hex: "#F4A38C"),
        durationMs: 4_400,
        delayMs: 2_600
    ),
    ParticleSpec(
        id: 2,
        x: BOX_CENTER - 34,
        y: 10,
        radius: 6,
        color: Color(hex: "#EF9A8E"),
        durationMs: 3_800,
        delayMs: 1_800
    ),
    ParticleSpec(
        id: 3,
        x: BOX_CENTER + 34,
        y: 10,
        radius: 6,
        color: Color(hex: "#F6C07A"),
        durationMs: 4_000,
        delayMs: 900
    ),
]

struct Particles: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            ForEach(particleSpecs) { spec in
                Particle(
                    spec: spec,
                    stageScale: size / BOX_SIZE
                )
            }
        }
        .frame(width: size, height: size)
    }
}

private struct Particle: View {
    let spec: ParticleSpec
    let stageScale: CGFloat

    var body: some View {
        let centerX = spec.x * stageScale
        let centerY = spec.y * stageScale
        let radius = spec.radius * stageScale

        RiseLoop(
            durationMs: spec.durationMs,
            delayMs: spec.delayMs
        ) { progress in
            let progress = CGFloat(progress)
            let scale = GlowMath.linearInterpolate(
                ParticleMotion.scaleMin,
                ParticleMotion.scaleMax,
                progress
            )
            let translateY = GlowMath.linearInterpolate(
                ParticleMotion.translateYMin,
                ParticleMotion.translateYMax,
                progress
            )
            let opacity = GlowMath.calcTriangleOpacity(
                progress: progress,
                fadeIn: ParticleMotion.fadeIn
            )
            let transform = GlowMath.calcTransform(
                scale: scale,
                cx: centerX,
                cy: centerY,
                ty: translateY * stageScale
            )

            RoundedRectangle(cornerRadius: radius * 0.4)
                .fill(spec.color)
                .frame(width: radius * 2, height: radius * 2)
                .rotationEffect(.degrees(45))
                .scaleEffect(transform.scale)
                .opacity(opacity)
                .position(
                    x: transform.center.x + transform.translation.width,
                    y: transform.center.y + transform.translation.height
                )
        }
    }
}

#if DEBUG
#Preview("Particles") {
    Particles(size: BOX_SIZE)
        .background(screenBackground[.energetic]!.colors[1])
        .padding()
}
#endif
