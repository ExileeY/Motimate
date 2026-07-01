import SwiftUI

extension Color {
    init(hex: String) {
        let h = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        var v: UInt64 = 0
        Scanner(string: h).scanHexInt64(&v)
        self.init(
            red: Double((v >> 16) & 0xFF) / 255,
            green: Double((v >> 8) & 0xFF) / 255,
            blue: Double(v & 0xFF) / 255
        )
    }

    init(r: Double, g: Double, b: Double, a: Double) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, opacity: a)
    }
}

/// Shared terracotta-cream palette (mood-independent).
enum Colors {
    static let text = Color(hex: "#503A29")          // headings / brand
    static let accent = Color(hex: "#C77E45")        // brand dot + "mood" word
    static let pillText = Color(hex: "#6B4F3F")      // time-of-day pill label + card title
    static let clock = Color(hex: "#8A6F58")         // clock time
    static let subtitle = Color(hex: "#967A60")      // pet subtitle
    static let cardMeta = Color(hex: "#A98C76")      // card right-hand meta
    static let cardFooter = Color(hex: "#9A8472")    // card footer line
    static let pillBg = Color(r: 255, g: 247, b: 237, a: 0.6)
    static let pillBorder = Color(r: 214, g: 150, b: 100, a: 0.22)
    static let cardBg = Color(r: 255, g: 247, b: 237, a: 0.55)
    static let cardBorder = Color(r: 214, g: 150, b: 100, a: 0.18)
    static let barTrack = Color(r: 140, g: 90, b: 55, a: 0.12)
    static let barFrom = Color(hex: "#F0B07A")       // progress bar gradient start
    static let barTo = Color(hex: "#E08A4F")         // progress bar gradient end
}

enum Fonts {
    static func heading(_ size: CGFloat) -> Font { .custom("Fredoka-SemiBold", size: size) }
    static func headingMedium(_ size: CGFloat) -> Font { .custom("Fredoka-Medium", size: size) }
    static func bodyRegular(_ size: CGFloat) -> Font { .custom("Nunito-Regular", size: size) }
    static func bodyBold(_ size: CGFloat) -> Font { .custom("Nunito-Bold", size: size) }
}

struct ScreenBackground {
    let locations: [CGFloat]
    let colors: [Color]
}

let screenBackground: [Mood: ScreenBackground] = [
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
]

/// The soft circular halo behind the pet. In the mockups this is a blurred
/// `radial-gradient(circle, rgba(...,a), rgba(...,0) 68%)` that pulses.
struct GlowSpec {
    let size: CGFloat        // diameter (236 / 220 / 206)
    let color: Color         // inner rgb
    let opacity: Double      // inner alpha
    let pulseDuration: Double // glowPulse ms
}

let glow: [Mood: GlowSpec] = [
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
        color:
        Color(hex: "#BED6EC"),
        opacity: 0.8,
        pulseDuration: 5500
    ),
]

let statusDot: [Mood: Color] = [
    .energetic: Color(hex: "#C9824F"),
    .calm: Color(hex: "#E0A95C"),
    .tired: Color(hex: "#B98E5E"),
    .sad: Color(hex: "#7FA3C9"),
]

#if DEBUG
/// Confirms the bundled fonts resolve (no Helvetica fallback) and previews the
/// per-mood gradient + glow + status-dot tables.
#Preview("Tokens") {
    VStack(alignment: .leading, spacing: 16) {
        VStack(alignment: .leading, spacing: 4) {
            Text("Fredoka SemiBold").font(Fonts.heading(22)).foregroundColor(Colors.text)
            Text("Fredoka Medium").font(Fonts.headingMedium(18)).foregroundColor(Colors.pillText)
            Text("Nunito Regular — the quick brown fox").font(Fonts.bodyRegular(15)).foregroundColor(Colors.subtitle)
            Text("Nunito Bold — the quick brown fox").font(Fonts.bodyBold(15)).foregroundColor(Colors.text)
        }
        ForEach(Mood.allCases, id: \.self) { mood in
            let bg = screenBackground[mood]!
            HStack(spacing: 12) {
                LinearGradient(
                    stops: zip(bg.colors, bg.locations).map { Gradient.Stop(color: $0, location: $1) },
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 120, height: 44)
                .cornerRadius(8)
                Circle().fill(glow[mood]!.color).frame(width: 28, height: 28)
                Circle().fill(statusDot[mood]!).frame(width: 14, height: 14)
                Text(mood.rawValue).font(Fonts.bodyRegular(13)).foregroundColor(Colors.cardMeta)
            }
        }
    }
    .padding()
}
#endif
