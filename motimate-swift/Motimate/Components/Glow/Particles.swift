import SwiftUI

private enum ParticleMotion {
    static let translateYMin: CGFloat = 10
    static let translateYMax: CGFloat = -40
    static let scaleMin: CGFloat = 0.6
    static let scaleMax: CGFloat = 1
    static let fadeIn: CGFloat = 0.28
}

private let particlePalette = [
    Color(hex: "#F4A38C"),
    Color(hex: "#EF9A8E"),
    Color(hex: "#F6C07A"),
]
private let particleRadii: [CGFloat] = [6, 7.5, 9]

private struct ParticlePairConfig {
    let dxFraction: CGFloat
    let yFraction: CGFloat
    let leftDurationMs: Double
    let leftDelayMs: Double
    let rightDurationMs: Double
    let rightDelayMs: Double
}

private let particlePairConfigs: [ParticlePairConfig] = [
    ParticlePairConfig(
        dxFraction: 0.303,
        yFraction: 0.12,
        leftDurationMs: 3_400,
        leftDelayMs: 0,
        rightDurationMs: 4_400,
        rightDelayMs: 2_600
    ),
    ParticlePairConfig(
        dxFraction: 0.179,
        yFraction: 0.21,
        leftDurationMs: 3_800,
        leftDelayMs: 1_800,
        rightDurationMs: 4_000,
        rightDelayMs: 900
    ),
    ParticlePairConfig(
        dxFraction: 0.385,
        yFraction: 0.3,
        leftDurationMs: 4_200,
        leftDelayMs: 3_100,
        rightDurationMs: 3_600,
        rightDelayMs: 1_400
    ),
    ParticlePairConfig(
        dxFraction: 0.113,
        yFraction: 0.07,
        leftDurationMs: 4_000,
        leftDelayMs: 2_200,
        rightDurationMs: 3_500,
        rightDelayMs: 700
    ),
    ParticlePairConfig(
        dxFraction: 0,
        yFraction: 0.39,
        leftDurationMs: 4_400,
        leftDelayMs: 1_200,
        rightDurationMs: 0,
        rightDelayMs: 0
    ),
    ParticlePairConfig(
        dxFraction: 0.246,
        yFraction: 0.48,
        leftDurationMs: 3_900,
        leftDelayMs: 2_400,
        rightDurationMs: 4_300,
        rightDelayMs: 600
    ),
    ParticlePairConfig(
        dxFraction: 0.338,
        yFraction: 0.58,
        leftDurationMs: 4_100,
        leftDelayMs: 800,
        rightDurationMs: 3_700,
        rightDelayMs: 2_900
    ),
    ParticlePairConfig(
        dxFraction: 0.149,
        yFraction: 0.67,
        leftDurationMs: 4_500,
        leftDelayMs: 1_600,
        rightDurationMs: 3_300,
        rightDelayMs: 3_400
    ),
]

private struct BackgroundParticleSpec: Identifiable {
    let id: Int
    let position: CGPoint
    let radius: CGFloat
    let color: Color
    let durationMs: Double
    let delayMs: Double
}

struct BackgroundParticles: View {
    let area: CGSize

    private let specs: [BackgroundParticleSpec]

    init(area: CGSize) {
        self.area = area
        self.specs = BackgroundParticles.makeSpecs(area: area)
    }

    var body: some View {
        ZStack {
            ForEach(specs) { spec in
                Particle(
                    center: spec.position,
                    radius: spec.radius,
                    color: spec.color,
                    durationMs: spec.durationMs,
                    delayMs: spec.delayMs
                )
            }
        }
        .frame(width: area.width, height: area.height)
    }

    private static func makeSpecs(area: CGSize) -> [BackgroundParticleSpec] {
        let centerX = area.width / 2

        var specs: [BackgroundParticleSpec] = []

        for config in particlePairConfigs {
            let color = particlePalette.randomElement()!
            let radius = particleRadii.randomElement()!
            let dx = config.dxFraction * area.width
            let y = config.yFraction * area.height

            specs.append(
                BackgroundParticleSpec(
                    id: specs.count,
                    position: CGPoint(x: centerX - dx, y: y),
                    radius: radius,
                    color: color,
                    durationMs: config.leftDurationMs,
                    delayMs: config.leftDelayMs
                )
            )

            guard config.dxFraction > 0 else { continue }

            specs.append(
                BackgroundParticleSpec(
                    id: specs.count,
                    position: CGPoint(x: centerX + dx, y: y),
                    radius: radius,
                    color: color,
                    durationMs: config.rightDurationMs,
                    delayMs: config.rightDelayMs
                )
            )
        }

        return specs
    }
}

private struct Particle: View {
    let center: CGPoint
    let radius: CGFloat
    let color: Color
    let durationMs: Double
    let delayMs: Double

    var body: some View {
        RiseLoop(
            durationMs: durationMs,
            delayMs: delayMs
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
                cx: center.x,
                cy: center.y,
                ty: translateY
            )

            RoundedRectangle(cornerRadius: radius * 0.4)
                .fill(color)
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
#Preview("BackgroundParticles") {
    GeometryReader { geo in
        BackgroundParticles(area: geo.size)
    }
    .background(screenBackground[.energetic]!.colors[1])
    .ignoresSafeArea()
}
#endif
