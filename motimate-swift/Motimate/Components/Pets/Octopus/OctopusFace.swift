import SwiftUI

struct OctopusFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat

    private static let MOUTH = Color(hex: "#4A352A")

    var body: some View {
        switch mood {
        case .energetic:
            ZStack {
                openEyes
                cheeks(opacity: 0.45)

                // Smile
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 81,
                    dy: 78,
                    d: "q 9 11 18 0",
                    color: Self.MOUTH
                )
            }
        case .calm:
            ZStack {
                openEyes
                cheeks(opacity: 0.45)

                // Smile
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 82.5,
                    dy: 78,
                    d: "q 7.5 10 15 0",
                    color: Self.MOUTH
                )
            }
        case .tired:
            ZStack {
                // Eyes
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 26,
                    dy: 46,
                    d: "q 13 12 26 0",
                    color: Self.MOUTH
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 128,
                    dy: 46,
                    d: "q 13 12 26 0",
                    color: Self.MOUTH
                )
                cheeks(opacity: 0.4)


                // Tiny mouth
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 84,
                    dy: 80,
                    d: "q 6 7 12 0",
                    color: Self.MOUTH
                )
            }
        case .sad:
            ZStack {
                openEyes
                cheeks(opacity: 0.4)

                // Frown
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 81,
                    dy: 84,
                    d: "q 9 -8 18 0",
                    color: Self.MOUTH
                )
            }
        }
    }

    private func cheeks(opacity: Double) -> some View {
        ZStack {
            Cheek(
                ox: ox,
                oy: oy,
                dx: 28,
                dy: 80.5,
                color: Color(hex: "#E8736B"),
                opacity: opacity,
                rx: 10,
                ry: 6.5,
                blur: 1.08
            )
            Cheek(
                ox: ox,
                oy: oy,
                dx: 152,
                dy: 80.5,
                color: Color(hex: "#E8736B"),
                opacity: opacity,
                rx: 10,
                ry: 6.5,
                blur: 1.08
            )
        }
    }

    private var openEyes: some View {
        ZStack {
            OctopusEye(
                ox: ox,
                oy: oy,
                dx: 24,
                dy: 34,
                irisX: 9,
                irisY: 12
            )
            OctopusEye(
                ox: ox,
                oy: oy,
                dx: 124,
                dy: 34,
                irisX: 8,
                irisY: 12
            )
        }
    }
}
