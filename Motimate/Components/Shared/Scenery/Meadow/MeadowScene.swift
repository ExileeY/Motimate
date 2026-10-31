import SwiftUI

/// The Meadow scenery: sky, sun, mountain, drifting clouds and grass hills.
/// `mood` effects the styles in which the scene will be presented.
/// `groundY` (fraction of height) moves the hills under the pet's feet.
struct MeadowScene: View {
    let mood: Mood
    var groundY: CGFloat? = nil

    var body: some View {
        let spec = MeadowTokens.spec(mood)
        let layout = SceneryLayout.make(groundY: groundY)

        GeometryReader { geo in
            let size = geo.size

            ZStack(alignment: .topLeading) {
                LinearGradient(
                    stops: spec.sky.stops,
                    startPoint: .top,
                    endPoint: .bottom
                )

                SceneSun(sun: spec.sun, area: size)

                MeadowMountain(
                    baseShift: layout.shiftForGround,
                    peakShift: layout.shiftForBackdrop
                )
                    .fill(LinearGradient(colors: MeadowTokens.mountain, startPoint: .top, endPoint: .bottom))
                MeadowSnowCaps(yShift: layout.shiftForBackdrop)
                    .fill(MeadowTokens.snow)

                SceneClouds(configs: meadowClouds, color: MeadowTokens.cloud, area: size)

                RollingHill(startY: 0.60 + layout.shiftForGround, endY: 0.58 + layout.shiftForGround, peakRise: 0.05, valleyDepth: 0.03)
                    .fill(spec.ground.grassColor)
                RollingHill(startY: 0.66 + layout.shiftForGround, endY: 0.63 + layout.shiftForGround, peakRise: 0.05, valleyDepth: 0.05)
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

// Clouds

private let meadowClouds: [SceneCloudConfig] = [
    SceneCloudConfig(x: 0.18, y: 0.09, scale: 1.1, alpha: 0.85, drift: 0.05, durationMs: 16_000),
    SceneCloudConfig(x: 0.52, y: 0.19, scale: 0.8, alpha: 0.75, drift: 0.06, durationMs: 21_000),
    SceneCloudConfig(x: 0.88, y: 0.36, scale: 0.95, alpha: 0.8, drift: 0.04, durationMs: 18_000),
]

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
