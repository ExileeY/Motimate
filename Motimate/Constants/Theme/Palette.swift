import SwiftUI

struct Palette {
    let text: Color          // headings / brand
    let accent: Color        // brand dot + "mood" word
    let pillText: Color      // time-of-day pill label + card title
    let clock: Color         // clock time
    let subtitle: Color      // pet subtitle
    let cardMeta: Color      // card right-hand meta
    let cardFooter: Color    // card footer line
    let pillBg: Color
    let pillBorder: Color
    let cardBg: Color
    let cardBorder: Color
    let barTrack: Color
    let barFrom: Color       // progress bar gradient start
    let barTo: Color         // progress bar gradient end

    static let day = Palette(
        text: Color(hex: "#503A29"),
        accent: Color(hex: "#C77E45"),
        pillText: Color(hex: "#6B4F3F"),
        clock: Color(hex: "#8A6F58"),
        subtitle: Color(hex: "#967A60"),
        cardMeta: Color(hex: "#A98C76"),
        cardFooter: Color(hex: "#9A8472"),
        pillBg: Color(r: 255, g: 247, b: 237, a: 0.6),
        pillBorder: Color(r: 214, g: 150, b: 100, a: 0.22),
        cardBg: Color(r: 255, g: 247, b: 237, a: 0.55),
        cardBorder: Color(r: 214, g: 150, b: 100, a: 0.18),
        barTrack: Color(r: 140, g: 90, b: 55, a: 0.12),
        barFrom: Color(hex: "#F0B07A"),
        barTo: Color(hex: "#E08A4F")
    )

    static let night = Palette(
        text: Color(hex: "#F3E4D3"),
        accent: Color(hex: "#E0954F"),
        pillText: Color(hex: "#EAD5C1"),
        clock: Color(hex: "#B6987F"),
        subtitle: Color(hex: "#B99C84"),
        cardMeta: Color(hex: "#A98C76"),
        cardFooter: Color(hex: "#A88E77"),
        pillBg: Color(r: 255, g: 240, b: 225, a: 0.07),
        pillBorder: Color(r: 224, g: 150, b: 80, a: 0.28),
        cardBg: Color(r: 255, g: 240, b: 225, a: 0.05),
        cardBorder: Color(r: 224, g: 150, b: 80, a: 0.16),
        barTrack: Color(r: 255, g: 255, b: 255, a: 0.08),
        barFrom: Color(hex: "#F0B07A"),
        barTo: Color(hex: "#E08A4F")
    )
}

let Colors = Palette.day // Previews only.
