import SwiftUI

struct StatusDotTokens: MoodToken {
    let day: [Mood: Color]
    let night: Color
}

let statusDotData = StatusDotTokens(
    day: [
        .energetic: Color(hex: "#C9824F"),
        .calm: Color(hex: "#E0A95C"),
        .tired: Color(hex: "#B98E5E"),
        .sad: Color(hex: "#7FA3C9"),
    ],
    night: Color(hex: "#F0A85C")
)
