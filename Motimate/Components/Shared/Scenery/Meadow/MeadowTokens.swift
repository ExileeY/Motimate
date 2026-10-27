import SwiftUI

/// The Meadow sun config.
struct SunConfig {
    static let defaultX: CGFloat = 0.8
    static let defaultRadius: CGFloat = 0.07 // fraction of scene width
    static let defaultCloudOver: Bool = false

    let color: Color
    let glow: Color
    let x: CGFloat              // center, fraction of scene width
    let y: CGFloat              // center, fraction of scene height
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

/// The Meadow sky: a top → bottom gradient.
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

/// The grass hills and the pale ground beneath the home text.
struct GroundConfig {
    let grassColor: Color
    let groundColor: Color
}

/// Per-mood look of the Meadow scenery.
struct MeadowSpec {
    let sky: SkyConfig
    let sun: SunConfig
    let ground: GroundConfig
}

enum MeadowTokens {
    static let mountain: [Color] = [Color(hex: "#A3B1CB"), Color(hex: "#7F8EAC")]
    static let snow = Color(hex: "#F7FAFC")
    static let cloud = Color(hex: "#FFFFFF")

    static let day: [Mood: MeadowSpec] = [
        .energetic: MeadowSpec(
            sky: SkyConfig(colors: [Color(hex: "#9FD4F2"), Color(hex: "#C9E8F7"), Color(hex: "#EAF6FB")]),
            sun: SunConfig(
                color: Color(hex: "#FFD86B"),
                glow: Color(hex: "#FFE9A8"),
                y: 0.19,
                opacity: 1
            ),
            ground: GroundConfig(
                grassColor: Color(hex: "#8CCB6A"),
                groundColor: Color(hex: "#EAF4D9")
            )
        ),
        .calm: MeadowSpec(
            sky: SkyConfig(colors: [Color(hex: "#B5DDEF"), Color(hex: "#D6ECF5"), Color(hex: "#F1F7F4")]),
            sun: SunConfig(
                color: Color(hex: "#FFE08A"),
                glow: Color(hex: "#FFF0C2"),
                y: 0.21,
                opacity: 0.9
            ),
            ground: GroundConfig(
                grassColor: Color(hex: "#9CCB7C"),
                groundColor: Color(hex: "#EEF4E0")
            )
        ),
        .tired: MeadowSpec(
            sky: SkyConfig(colors: [Color(hex: "#F2C79B"), Color(hex: "#F7DDBE"), Color(hex: "#FBEBD8")]),
            sun: SunConfig(
                color: Color(hex: "#FFB070"),
                glow: Color(hex: "#FFD3A8"),
                y: 0.3,
                opacity: 0.85
            ),
            ground: GroundConfig(
                grassColor: Color(hex: "#93B86E"),
                groundColor: Color(hex: "#F5EBD3")
            )
        ),
        .sad: MeadowSpec(
            sky: SkyConfig(colors: [Color(hex: "#B8C7D4"), Color(hex: "#CED8E1"), Color(hex: "#E2E8EC")]),
            sun: SunConfig(
                color: Color(hex: "#F3E3A6"),
                glow: Color(hex: "#F5ECCB"),
                y: 0.2,
                opacity: 0.6
            ),
            ground: GroundConfig(
                grassColor: Color(hex: "#8FA97E"),
                groundColor: Color(hex: "#E4EAE0")
            )
        ),
    ]

    static func spec(_ mood: Mood) -> MeadowSpec {
        day[mood]!
    }
}
