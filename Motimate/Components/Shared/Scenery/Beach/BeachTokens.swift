import SwiftUI

/// The sea: `far` at the horizon → `near` at the shoreline.
struct SeaConfig {
    let far: Color
    let near: Color
}

/// The dry sand, the wet strip at the waterline and the pale ground beneath the home text.
struct SandConfig {
    let sand: Color
    let wet: Color
    let ground: Color
}

/// Per-mood look of the Beach scenery.
struct BeachSpec {
    let sky: SkyConfig
    let sun: SunConfig
    let sea: SeaConfig
    let sand: SandConfig
}

enum BeachTokens {
    static let foam = Color(hex: "#FFFFFF")
    static let cloud = Color(hex: "#FFFFFF")
    static let palmTrunk: [Color] = [Color(hex: "#A9825A"), Color(hex: "#7E5C3D")]
    static let frondBack = Color(hex: "#3F9B6A")
    static let frondFront = Color(hex: "#5CB87F")
    static let coconut = Color(hex: "#6B4A2F")

    static let day: [Mood: BeachSpec] = [
        .energetic: BeachSpec(
            sky: SkyConfig(colors: [Color(hex: "#7FCDF2"), Color(hex: "#B4E4F7"), Color(hex: "#E6F7FB")]),
            sun: SunConfig(
                color: Color(hex: "#FFD86B"),
                glow: Color(hex: "#FFE9A8"),
                y: 0.19,
                opacity: 1
            ),
            sea: SeaConfig(far: Color(hex: "#2FA8CF"), near: Color(hex: "#7FDCD6")),
            sand: SandConfig(
                sand: Color(hex: "#F4DDA6"),
                wet: Color(hex: "#D9BC83"),
                ground: Color(hex: "#FBF1D6")
            )
        ),
        .calm: BeachSpec(
            sky: SkyConfig(colors: [Color(hex: "#A5DBF0"), Color(hex: "#CBEAF5"), Color(hex: "#EEF8F6")]),
            sun: SunConfig(
                color: Color(hex: "#FFE08A"),
                glow: Color(hex: "#FFF0C2"),
                y: 0.21,
                opacity: 0.9
            ),
            sea: SeaConfig(far: Color(hex: "#57B5CF"), near: Color(hex: "#9BE0D8")),
            sand: SandConfig(
                sand: Color(hex: "#F3E0B3"),
                wet: Color(hex: "#DCC491"),
                ground: Color(hex: "#FAF3DF")
            )
        ),
        .tired: BeachSpec(
            sky: SkyConfig(colors: [Color(hex: "#F2B98F"), Color(hex: "#F8D5B0"), Color(hex: "#FCE9D2")]),
            sun: SunConfig(
                color: Color(hex: "#FFB070"),
                glow: Color(hex: "#FFD3A8"),
                y: 0.3,
                opacity: 0.85
            ),
            sea: SeaConfig(far: Color(hex: "#5E97B4"), near: Color(hex: "#E7B99A")),
            sand: SandConfig(
                sand: Color(hex: "#EFD2A0"),
                wet: Color(hex: "#CFA87A"),
                ground: Color(hex: "#F9ECD2")
            )
        ),
        .sad: BeachSpec(
            sky: SkyConfig(colors: [Color(hex: "#B3C3D1"), Color(hex: "#CAD6DF"), Color(hex: "#E0E6EB")]),
            sun: SunConfig(
                color: Color(hex: "#F3E3A6"),
                glow: Color(hex: "#F5ECCB"),
                y: 0.2,
                opacity: 0.6
            ),
            sea: SeaConfig(far: Color(hex: "#7E9BAE"), near: Color(hex: "#A9C1C6")),
            sand: SandConfig(
                sand: Color(hex: "#DCCFB3"),
                wet: Color(hex: "#BDAF94"),
                ground: Color(hex: "#EAE5D8")
            )
        ),
    ]

    static func spec(_ mood: Mood) -> BeachSpec {
        day[mood]!
    }
}
