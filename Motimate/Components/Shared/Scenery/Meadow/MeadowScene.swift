import SwiftUI

/// The Meadow scenery: sky, sun, mountain, drifting clouds and grass hills.
/// `mood` effects the styles in which the scene will be presented.
/// `groundY` (fraction of height) moves the hills under the pet's feet.
struct MeadowScene: View {
    let mood: Mood
    var groundY: CGFloat? = nil

    var body: some View {
        let spec = MeadowTokens.spec(mood)
        let layout = MeadowLayout.make(groundY: groundY)

        GeometryReader { geo in
            let size = geo.size

            ZStack(alignment: .topLeading) {
                LinearGradient(
                    stops: spec.sky.stops,
                    startPoint: .top,
                    endPoint: .bottom
                )

                MeadowSun(sun: spec.sun, area: size)

                MeadowMountain(
                    baseShift: layout.shiftForGround,
                    peakShift: layout.shiftForPeak
                )
                    .fill(LinearGradient(colors: MeadowTokens.mountain, startPoint: .top, endPoint: .bottom))
                MeadowSnowCaps(yShift: layout.shiftForPeak)
                    .fill(MeadowTokens.snow)

                MeadowClouds(area: size)

                MeadowHill(startY: 0.60 + layout.shiftForGround, endY: 0.58 + layout.shiftForGround, peakRise: 0.05, valleyDepth: 0.03)
                    .fill(spec.ground.grassColor)
                MeadowHill(startY: 0.66 + layout.shiftForGround, endY: 0.63 + layout.shiftForGround, peakRise: 0.05, valleyDepth: 0.05)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: spec.ground.grassColor, location: 0),
                                Gradient.Stop(color: spec.ground.groundColor, location: 0.22),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .frame(width: size.width, height: size.height)
        }
        .allowsHitTesting(false)
    }
}

// Sun

private struct MeadowSun: View {
    let sun: SunConfig
    let area: CGSize

    var body: some View {
        let radius = sun.radius * area.width
        let center = CGPoint(x: sun.x * area.width, y: sun.y * area.height)

        PingPongLoop(durationMs: 4_000) { progress in
            let haloScale = MathUtils.linearInterpolate(1, 1.08, CGFloat(progress))

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [sun.glow.opacity(0.9), sun.glow.opacity(0)],
                            center: .center,
                            startRadius: radius * 0.8,
                            endRadius: radius * 2.4
                        )
                    )
                    .frame(width: radius * 4.8, height: radius * 4.8)
                    .scaleEffect(haloScale)

                Circle()
                    .fill(sun.color)
                    .frame(width: radius * 2, height: radius * 2)
            }
            .opacity(sun.opacity)
            .position(center)
        }
    }
}

// Clouds

private struct MeadowCloudConfig {
    let x: CGFloat          // fraction of width
    let y: CGFloat          // fraction of height
    let scale: CGFloat
    let alpha: CGFloat
    let drift: CGFloat      // horizontal travel, fraction of width
    let durationMs: Double
}

private let meadowClouds: [MeadowCloudConfig] = [
    MeadowCloudConfig(x: 0.18, y: 0.09, scale: 1.1, alpha: 0.85, drift: 0.05, durationMs: 16_000),
    MeadowCloudConfig(x: 0.52, y: 0.19, scale: 0.8, alpha: 0.75, drift: 0.06, durationMs: 21_000),
    MeadowCloudConfig(x: 0.88, y: 0.36, scale: 0.95, alpha: 0.8, drift: 0.04, durationMs: 18_000),
]

private struct MeadowClouds: View {
    let area: CGSize

    /// `CloudPuff` is authored in points for a ~390pt-wide screen.
    private static let referenceWidth: CGFloat = 390

    var body: some View {
        let unit = area.width / Self.referenceWidth

        ZStack(alignment: .topLeading) {
            ForEach(Array(meadowClouds.enumerated()), id: \.offset) { _, config in
                PingPongLoop(durationMs: config.durationMs) { progress in
                    let dx = (CGFloat(progress) - 0.5) * 2 * config.drift * area.width

                    CloudPuff(color: MeadowTokens.cloud, alpha: config.alpha)
                        .scaleEffect(config.scale * unit)
                        .position(x: config.x * area.width + dx, y: config.y * area.height)
                }
            }
        }
        .frame(width: area.width, height: area.height)
    }
}

#if DEBUG
#Preview("MeadowScene Moods") {
    VStack(spacing: 0) {
        ForEach(Mood.allCases, id: \.self) { mood in
            MeadowScene(mood: mood)
                .frame(height: 200)
        }
    }
}
#endif
