import SwiftUI

struct GlowSpec {
    let size: CGFloat        // diameter (236 / 220 / 206)
    let color: Color         // inner rgb
    let opacity: Double      // inner alpha
    let pulseDuration: Double // glowPulse ms
}

struct StageGlowTokens: MoodToken {
    let day: [Mood: GlowSpec]
    let night: GlowSpec
}

let glowData = StageGlowTokens(
    day: [
        .energetic: GlowSpec(
            size: 236,
            color: Color(hex: "#FFDEB6"),
            opacity: 0.95,
            pulseDuration: 5500
        ),
        .calm: GlowSpec(
            size: 220,
            color: Color(hex: "#FAE2C6"),
            opacity: 0.7,
            pulseDuration: 7000
        ),
        .tired: GlowSpec(
            size: 206,
            color: Color(hex: "#FFEEDC"),
            opacity: 0.6,
            pulseDuration: 8000
        ),
        .sad: GlowSpec(
            size: 236,
            color: Color(hex: "#BED6EC"),
            opacity: 0.8,
            pulseDuration: 5500
        ),
    ],
    night: GlowSpec(
        size: 240,
        color: Color(hex: "#FFC48C"),
        opacity: 0.26,
        pulseDuration: 5500
    )
)
