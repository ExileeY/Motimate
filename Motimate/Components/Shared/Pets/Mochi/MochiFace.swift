import SwiftUI

struct MochiFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat

    var body: some View {
        switch mood {
        case .energetic:
            ZStack {
                RoundEye(
                    ox: ox,
                    oy: oy,
                    dx: 48,
                    dy: 60
                )
                RoundEye(
                    ox: ox,
                    oy: oy,
                    dx: 100,
                    dy: 60
                )

                cheeks(dy: 70 + 7.5, opacity: 0.5)

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 65,
                    dy: 80,
                    d: "q 9 11 18 0",
                    color: Color(hex: "#4A352A")
                )
            }
        case .calm:
            ZStack {
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 39,
                    dy: 64,
                    d: "q 10 -11 20 0",
                    color: Color(hex: "#4A352A")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 89,
                    dy: 64,
                    d: "q 10 -11 20 0",
                    color: Color(hex: "#4A352A")
                )

                cheeks(dy: 72 + 7.5, opacity: 0.5)

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 66,
                    dy: 84,
                    d: "q 7.5 9 15 0",
                    color: Color(hex: "#4A352A")
                )
            }
        case .tired:
            ZStack {
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 41,
                    dy: 66,
                    d:"q 8.5 9 17 0",
                    color: Color(hex: "#6B4F3F")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 90,
                    dy: 66,
                    d:"q 8.5 9 17 0",
                    color: Color(hex: "#6B4F3F")
                )

                cheeks(dy: 74 + 6.5, opacity: 0.45)

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 67.5,
                    dy: 88,
                    d: "q 6.5 8 13 0", color: Color(hex: "#6B4F3F"))
            }
        case .sad:
            ZStack {
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 41,
                    dy: 62,
                    d: "q 9 9 18 0",
                    color: Color(hex: "#4A352A")
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 91,
                    dy: 62,
                    d: "q 9 9 18 0",
                    color: Color(hex: "#4A352A")
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 66,
                    dy: 92,
                    d: "q 7.5 -8 15 0",
                    color: Color(hex: "#4A352A")
                )
            }
        }
    }

    private func cheeks(dy: CGFloat, opacity: Double) -> some View {
        ZStack {
            Cheek(
                ox: ox,
                oy: oy,
                dx: 33,
                dy: dy,
                opacity: opacity,
                blur: 1.2
            )
            Cheek(
                ox: ox,
                oy: oy,
                dx: 115,
                dy: dy,
                opacity: opacity,
                blur: 1.2
            )
        }
    }
}
