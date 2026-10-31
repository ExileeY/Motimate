import SwiftUI

/// A scenery's sun config.
struct SunConfig {
    static let defaultX: CGFloat = 0.8
    static let defaultRadius: CGFloat = 0.07 // fraction of scene width
    static let defaultCloudOver: Bool = false

    let color: Color
    let glow: Color
    let x: CGFloat // center, fraction of scene width
    let y: CGFloat // center, fraction of scene height
    let radius: CGFloat
    let opacity: Double

    init(
        color: Color,
        glow: Color,
        x: CGFloat = SunConfig.defaultX,
        y: CGFloat,
        radius: CGFloat = SunConfig.defaultRadius,
        opacity: Double
    ) {
        self.color = color
        self.glow = glow
        self.x = x
        self.y = y
        self.radius = radius
        self.opacity = opacity
    }
}

/// A scenery's sky: a top → bottom gradient.
struct SkyConfig {
    static let defaultLocations: [CGFloat] = [0, 0.55, 1]

    let colors: [Color]
    let locations: [CGFloat]

    init(colors: [Color], locations: [CGFloat] = SkyConfig.defaultLocations) {
        self.colors = colors
        self.locations = locations
    }

    var stops: [Gradient.Stop] {
        zip(colors, locations).map { Gradient.Stop(color: $0, location: $1) }
    }
}

struct SceneSun: View {
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
