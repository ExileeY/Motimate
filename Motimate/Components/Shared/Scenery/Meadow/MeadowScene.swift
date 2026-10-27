import SwiftUI

/// The Meadow scenery: sky, sun, mountain, drifting clouds and grass hills.
struct MeadowScene: View {
    let mood: Mood

    var body: some View {
        let spec = MeadowTokens.spec(mood)

        GeometryReader { geo in
            let size = geo.size

            ZStack(alignment: .topLeading) {
                LinearGradient(
                    stops: spec.sky.stops,
                    startPoint: .top,
                    endPoint: .bottom
                )

                MeadowSun(sun: spec.sun, area: size)

                MeadowMountain()
                    .fill(LinearGradient(colors: MeadowTokens.mountain, startPoint: .top, endPoint: .bottom))
                MeadowSnowCaps()
                    .fill(MeadowTokens.snow)

                MeadowClouds(area: size)

                MeadowHill(startY: 0.60, endY: 0.58, peakRise: 0.05, valleyDepth: 0.03)
                    .fill(spec.ground.grassColor)
                MeadowHill(startY: 0.66, endY: 0.63, peakRise: 0.05, valleyDepth: 0.05)
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

// MARK: - Shapes (fractions of rect)

private func point(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat) -> CGPoint {
    CGPoint(x: rect.minX + x * rect.width, y: rect.minY + y * rect.height)
}

private func polygon(_ rect: CGRect, _ points: [(CGFloat, CGFloat)]) -> Path {
    var path = Path()
    path.addLines(points.map { point(rect, $0.0, $0.1) })
    path.closeSubpath()
    return path
}

private struct MeadowMountain: Shape {
    func path(in rect: CGRect) -> Path {
        polygon(rect, [
            (0, 0.56), (0.12, 0.50), (0.30, 0.36), (0.46, 0.49),
            (0.56, 0.46), (0.74, 0.40), (0.92, 0.52), (1, 0.55),
            (1, 0.66), (0, 0.66),
        ])
    }
}

/// Caps sit exactly on the ridge lines of `MeadowMountain`'s two peaks.
private struct MeadowSnowCaps: Shape {
    func path(in rect: CGRect) -> Path {
        var path = polygon(rect, [
            (0.26, 0.391), (0.30, 0.36), (0.34, 0.3925),
            (0.32, 0.385), (0.30, 0.398), (0.28, 0.385),
        ])
        path.addPath(polygon(rect, [
            (0.70, 0.413), (0.74, 0.40), (0.78, 0.427),
            (0.76, 0.42), (0.745, 0.43), (0.72, 0.418),
        ]))
        return path
    }
}

/// A rolling hill from `startY` (left edge) to `endY` (right edge), filled to the
/// bottom. `peakRise` raises the left bulge, `valleyDepth` lowers the right hollow.
private struct MeadowHill: Shape {
    let startY: CGFloat
    let endY: CGFloat
    let peakRise: CGFloat
    let valleyDepth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: point(rect, 0, startY))
        path.addCurve(
            to: point(rect, 1, endY),
            control1: point(rect, 0.3, startY - peakRise),
            control2: point(rect, 0.65, endY + valleyDepth)
        )
        path.addLine(to: point(rect, 1, 1))
        path.addLine(to: point(rect, 0, 1))
        path.closeSubpath()
        return path
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
