import SwiftUI

struct PlaceholderPetBody: View {
    let name: String
    let mood: Mood
    var size: CGFloat? = nil

    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let palette = tokens.palette
        let side = size ?? PET_SIZE
        VStack(spacing: 6) {
            Text(name)
                .font(Fonts.heading(20))
                .foregroundColor(palette.text)
            Text(mood.rawValue)
                .font(Fonts.bodyRegular(13))
                .foregroundColor(palette.subtitle)
        }
        .frame(width: side, height: side)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(palette.cardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(palette.cardBorder, lineWidth: 1)
                )
        )
    }
}

#if DEBUG
#Preview("Placeholder + shared primitives") {
    VStack(spacing: 24) {
        HStack(spacing: 12) {
            ForEach(Mood.allCases, id: \.self) { mood in
                PlaceholderPetBody(name: "Mochi", mood: mood, size: 80)
            }
        }

        ZStack {
            Cheek(ox: 60, oy: 60, dx: -20, dy: 0, opacity: 0.6, blur: 3)
            Cheek(ox: 60, oy: 60, dx: 20, dy: 0, opacity: 0.6, blur: 3)
            Arc(ox: 60, oy: 60, dx: -10, dy: 18, d: "q 10 8 20 0", color: Colors.text)
        }
        .frame(width: 120, height: 120)
        .background(Colors.cardBg)
    }
    .padding()
}
#endif
