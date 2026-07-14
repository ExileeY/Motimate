import SwiftUI

private enum CloudMotion {
    static let translateYMin: CGFloat = 20
    static let translateYMax: CGFloat = -80
    static let scaleMin: CGFloat = 0.9
    static let scaleMax: CGFloat = 1
    static let fadeIn: CGFloat = 0.2
}

private let cloudColor = Color(hex: "#FFFBF4")
private let cloudScales: [CGFloat] = [0.68, 0.95, 1.2, 1.4]
private let cloudAlphas: [CGFloat] = [0.42, 0.5, 0.55, 0.62]

private struct CloudConfig {
    let xFraction: CGFloat
    let yFraction: CGFloat
    let durationMs: Double
    let delayMs: Double
}

private let cloudConfigs: [CloudConfig] = [
    CloudConfig(
        xFraction: -0.34,
        yFraction: 0.16,
        durationMs: 20_000,
        delayMs: 0
    ),
    CloudConfig(
        xFraction: 0.21,
        yFraction: 0.28,
        durationMs: 26_000,
        delayMs: 9_000
    ),
    CloudConfig(
        xFraction: 0.42,
        yFraction: 0.41,
        durationMs: 24_000,
        delayMs: 4_000
    ),
    CloudConfig(
        xFraction: -0.11,
        yFraction: 0.09,
        durationMs: 31_000,
        delayMs: 14_000
    ),
    CloudConfig(
        xFraction: -0.44,
        yFraction: 0.53,
        durationMs: 22_000,
        delayMs: 6_000
    ),
    CloudConfig(
        xFraction: 0.06,
        yFraction: 0.65,
        durationMs: 18_000,
        delayMs: 11_000
    )
]

private struct CloudSpec: Identifiable {
    let id: Int
    let position: CGPoint
    let scale: CGFloat
    let alpha: CGFloat
    let color: Color
    let durationMs: Double
    let delayMs: Double
}

struct CloudDrift: View {
    let area: CGSize

    private let specs: [CloudSpec]

    init(area: CGSize) {
        self.area = area
        self.specs = CloudDrift.makeSpecs(area: area)
    }

    var body: some View {
        ZStack {
            ForEach(specs) { spec in
                Cloud(
                    center: spec.position,
                    scale: spec.scale,
                    alpha: spec.alpha,
                    color: spec.color,
                    durationMs: spec.durationMs,
                    delayMs: spec.delayMs
                )
            }
        }
        .frame(width: area.width, height: area.height)
    }

    private static func makeSpecs(area: CGSize) -> [CloudSpec] {
        cloudConfigs.enumerated().map { index, config in
            CloudSpec(
                id: index,
                position: CGPoint(
                    x: (0.5 + config.xFraction) * area.width,
                    y: config.yFraction * area.height
                ),
                scale: cloudScales.randomElement()!,
                alpha: cloudAlphas.randomElement()!,
                color: cloudColor,
                durationMs: config.durationMs,
                delayMs: config.delayMs
            )
        }
    }
}

private struct Cloud: View {
    let center: CGPoint
    let scale: CGFloat
    let alpha: CGFloat
    let color: Color
    let durationMs: Double
    let delayMs: Double

    var body: some View {
        RiseLoop(
            durationMs: durationMs,
            delayMs: delayMs
        ) { progress in
            let progress = CGFloat(progress)
            let riseScale = MathUtils.linearInterpolate(
                CloudMotion.scaleMin,
                CloudMotion.scaleMax,
                progress
            )
            let translateY = MathUtils.linearInterpolate(
                CloudMotion.translateYMin,
                CloudMotion.translateYMax,
                progress
            )
            let opacity = GlowMath.calcTriangleOpacity(
                progress: progress,
                fadeIn: CloudMotion.fadeIn
            )
            let transform = GlowMath.calcTransform(
                scale: riseScale * scale,
                cx: center.x,
                cy: center.y,
                ty: translateY
            )

            CloudPuff(color: color, alpha: alpha)
                .scaleEffect(transform.scale)
                .opacity(opacity)
                .position(
                    x: transform.center.x + transform.translation.width,
                    y: transform.center.y + transform.translation.height
                )
        }
    }
}

private struct CloudPuff: View {
    let color: Color
    let alpha: CGFloat

    private static let offsets: [CGSize] = [
        CGSize(width: 0, height: 0),
        CGSize(width: 19, height: -7),
        CGSize(width: 39, height: 1),
        CGSize(width: -17, height: -3),
        CGSize(width: 7, height: 6),
    ]

    var body: some View {
        ZStack {
            ForEach(Array(CloudPuff.offsets.enumerated()), id: \.offset) { _, offset in
                RoundedRectangle(cornerRadius: 11)
                    .fill(color.opacity(alpha))
                    .frame(width: 58, height: 22)
                    .offset(offset)
            }
        }
        .blur(radius: 2.5)
    }
}

#if DEBUG
#Preview("CloudDrift") {
    GeometryReader { geo in
        CloudDrift(area: geo.size)
    }
    .background(ThemeTokens.day.screenBackground(.tired).colors[1])
    .ignoresSafeArea()
}
#endif
