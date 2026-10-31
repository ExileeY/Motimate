import SwiftUI

/// The Beach scenery: sky, sun, sea, drifting clouds, one palm and a sand ground.
/// `mood` effects the styles in which the scene will be presented.
/// `groundY` (fraction of height) moves the sand under the pet's feet.
struct BeachScene: View {
    let mood: Mood
    var groundY: CGFloat? = nil

    var body: some View {
        let spec = BeachTokens.spec(mood)
        let layout = SceneryLayout.make(groundY: groundY)
        let horizonY = BeachGeometry.horizonY + layout.shiftForBackdrop
        let shorelineY = BeachGeometry.shorelineY + layout.shiftForGround

        GeometryReader { geo in
            let size = geo.size

            ZStack(alignment: .topLeading) {
                LinearGradient(
                    stops: spec.sky.stops,
                    startPoint: .top,
                    endPoint: .bottom
                )

                SceneSun(sun: spec.sun, area: size)

                // A shape's gradient resolves against the whole scene, so the sea and
                // sand stops are placed at the shape's own (shifted) position.
                BeachGeometry.sea(shift: layout.shiftForBackdrop)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: spec.sea.far, location: horizonY),
                                Gradient.Stop(color: spec.sea.near, location: shorelineY),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                BeachGlints(horizonY: horizonY, shorelineY: shorelineY, area: size)

                SceneClouds(configs: beachClouds, color: BeachTokens.cloud, area: size)

                PingPongLoop(durationMs: 5_000) { progress in
                    BeachGeometry.foam(
                        shift: layout.shiftForGround,
                        lap: CGFloat(progress) * Self.foamLap
                    )
                    .fill(BeachTokens.foam.opacity(0.9))
                }

                BeachGeometry.wetSand(shift: layout.shiftForGround)
                    .fill(spec.sand.wet)

                BeachGeometry.drySand(shift: layout.shiftForGround)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: spec.sand.sand, location: shorelineY),
                                Gradient.Stop(color: spec.sand.ground, location: shorelineY + BeachGeometry.sandFadeDepth),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                BeachPalm(groundShift: layout.shiftForGround, area: size)
            }
            .frame(width: size.width, height: size.height)
        }
        .allowsHitTesting(false)
    }

    private static let foamLap: CGFloat = 0.012
}

// Clouds

private let beachClouds: [SceneCloudConfig] = [
    SceneCloudConfig(x: 0.5, y: 0.12, scale: 0.9, alpha: 0.85, drift: 0.05, durationMs: 19_000),
    SceneCloudConfig(x: 0.56, y: 0.26, scale: 0.75, alpha: 0.75, drift: 0.04, durationMs: 23_000),
]

// Glints

private struct BeachGlintConfig {
    let x: CGFloat          // fraction of width
    let depth: CGFloat      // 0 = horizon, 1 = shoreline
    let width: CGFloat      // fraction of width
    let durationMs: Double
}

private let beachGlints: [BeachGlintConfig] = [
    BeachGlintConfig(x: 0.22, depth: 0.55, width: 0.08, durationMs: 3_400),
    BeachGlintConfig(x: 0.48, depth: 0.28, width: 0.06, durationMs: 4_300),
    BeachGlintConfig(x: 0.68, depth: 0.68, width: 0.1, durationMs: 3_800),
    BeachGlintConfig(x: 0.88, depth: 0.38, width: 0.07, durationMs: 4_900),
]

private struct BeachGlints: View {
    let horizonY: CGFloat
    let shorelineY: CGFloat
    let area: CGSize

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(beachGlints.enumerated()), id: \.offset) { _, glint in
                PingPongLoop(durationMs: glint.durationMs) { progress in
                    let y = MathUtils.linearInterpolate(horizonY, shorelineY, glint.depth)

                    Capsule()
                        .fill(BeachTokens.foam)
                        .frame(width: glint.width * area.width, height: max(1, 0.008 * area.width))
                        .opacity(0.15 + 0.5 * Double(progress))
                        .position(x: glint.x * area.width, y: y * area.height)
                }
            }
        }
        .frame(width: area.width, height: area.height)
    }
}

// Palm

private struct BeachPalm: View {
    let groundShift: CGFloat
    let area: CGSize

    private static let rootX: CGFloat = 0.12        // fraction of scene width
    private static let rootY: CGFloat = 0.6         // fraction of scene height
    private static let maxHeightRatio: CGFloat = 0.34 // of scene height
    private static let maxWidthRatio: CGFloat = 0.62  // of scene width
    private static let swayDegrees = 1.5

    var body: some View {
        // Sized off the scene's smaller constraint rather than in scene fractions,
        // so the palm keeps its proportions in a square picker tile.
        let height = min(Self.maxHeightRatio * area.height, Self.maxWidthRatio * area.width)
        let width = height * BeachPalmGeometry.aspect
        let rootX = Self.rootX * area.width
        let rootY = (Self.rootY + groundShift) * area.height

        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.14))
                .frame(width: height * 0.26, height: height * 0.04)
                .blur(radius: height * 0.008)
                .position(x: BeachPalmGeometry.baseX * width, y: height)

            BeachPalmTrunk()
                .fill(
                    LinearGradient(
                        colors: BeachTokens.palmTrunk,
                        startPoint: UnitPoint(x: 0.25, y: 0.5),
                        endPoint: UnitPoint(x: 0.55, y: 0.5)
                    )
                )

            PingPongLoop(durationMs: 6_000) { progress in
                ZStack {
                    BeachPalmFronds(tips: BeachPalmFronds.back)
                        .fill(BeachTokens.frondBack)
                    BeachPalmFronds(tips: BeachPalmFronds.front)
                        .fill(BeachTokens.frondFront)
                }
                .rotationEffect(
                    .degrees(-Self.swayDegrees + 2 * Self.swayDegrees * Double(progress)),
                    anchor: BeachPalmGeometry.crown
                )
            }

            ForEach(Array(BeachPalmGeometry.coconuts.enumerated()), id: \.offset) { _, coconut in
                Circle()
                    .fill(BeachTokens.coconut)
                    .frame(width: height * 0.05, height: height * 0.05)
                    .position(x: coconut.x * width, y: coconut.y * height)
            }
        }
        .frame(width: width, height: height)
        .position(
            x: rootX + (0.5 - BeachPalmGeometry.baseX) * width,
            y: rootY - height / 2
        )
    }
}

#if DEBUG
#Preview("BeachScene Moods") {
    VStack(spacing: 0) {
        ForEach(Mood.allCases, id: \.self) { mood in
            BeachScene(mood: mood)
                .frame(height: 200)
        }
    }
}
#endif
