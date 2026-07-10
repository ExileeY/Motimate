import SwiftUI

struct ScreenBackground {
    let locations: [CGFloat]
    let colors: [Color]
}

struct ScreenBgTokens: MoodToken {
    let day: [Mood: ScreenBackground]
    let night: ScreenBackground
}

let screenBackgroundData = ScreenBgTokens(
    day: [
        .energetic: ScreenBackground(
            locations: [0, 0.44, 1],
            colors: [
                Color(hex: "#FCE0C2"),
                Color(hex: "#F6C49A"),
                Color(hex: "#EDA877")
            ]
        ),
        .calm: ScreenBackground(
            locations: [0, 0.5, 1],
            colors: [
                Color(hex: "#FBEAD6"),
                Color(hex: "#F4D7B6"),
                Color(hex: "#ECD4BC")
            ]
        ),
        .tired: ScreenBackground(
            locations: [0, 0.56, 1],
            colors: [
                Color(hex: "#F3E0CA"),
                Color(hex: "#E7C6A1"),
                Color(hex: "#D9B083")
            ]
        ),
        .sad: ScreenBackground(
            locations: [0, 0.5, 1],
            colors: [
                Color(hex: "#E4EDF4"),
                Color(hex: "#CFDCE8"),
                Color(hex: "#BFCFE0")
            ]
        ),
    ],
    night: ScreenBackground(
        locations: [0, 0.46, 1],
        colors: [
            Color(hex: "#4A3627"),
            Color(hex: "#33251C"),
            Color(hex: "#241811")
        ]
    )
)
