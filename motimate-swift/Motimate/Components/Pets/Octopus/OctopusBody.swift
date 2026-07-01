import SwiftUI

struct OctopusBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let HEAD = (
        x: CGFloat(19),
        y: CGFloat(18),
        w: CGFloat(142),
        h: CGFloat(118)
    )

    // Six arms
    private static let TENTACLE = (
        y: CGFloat(120),
        w: CGFloat(20),
        gap: CGFloat(2)
    )
    private static let TENTACLE_HEIGHTS: [CGFloat] = [40, 50, 46, 52, 44, 38]
    private static let TENTACLE_START_X: CGFloat = {
        let boxW = CGFloat(TENTACLE_HEIGHTS.count) * TENTACLE.w
            + CGFloat(TENTACLE_HEIGHTS.count - 1) * TENTACLE.gap
        return (SIZE - boxW) / 2
    }()

    var body: some View {
        let S = Self.SIZE

        ZStack {
            // Tentacles
            ForEach(Array(Self.TENTACLE_HEIGHTS.enumerated()), id: \.offset) { i, h in
                tentacle(index: i, height: h)
            }

            // Head
            head

            // Face
            OctopusFace(
                mood: mood,
                ox: 0,
                oy: 0
            )
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Tentacles

    private func tentacle(index: Int, height: CGFloat) -> some View {
        let T = Self.TENTACLE
        let x = Self.TENTACLE_START_X + CGFloat(index) * (T.w + T.gap)
        return Self.tentaclePath(x, height)
            .fill(verticalLinearGradient([
                GStop("#E58A7B", 0),
                GStop("#D5715F", 1),
            ]))
    }

    // MARK: - Head

    private var head: some View {
        let H = Self.HEAD
        let path = Self.headPath()
        return ZStack {
            // Body
            path.fill(radialGradient([
                GStop("#F4AE9D", 0),
                GStop("#E58A7B", 0.66),
                GStop("#D5715F", 1),
            ], cx: 0.5, cy: 0.24, r: 1.15, side: H.w))

            // Bottom shade
            path.fill(radialGradient([
                GStop("#A54637", 0.55, 0),
                GStop("#A54637", 1, 0.28),
            ], cx: 0.5, cy: 1, r: 0.6, side: H.w))

            // Top rim
            path.fill(radialGradient([
                GStop("#FFE0D4", 0, 0.55),
                GStop("#FFE0D4", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.44, side: H.w))
        }
    }

    // MARK: - Geometry

    private static func headPath() -> Path {
        roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
            (0.48, 0.6),
            (0.48, 0.6),
            (0.44, 0.4),
            (0.44, 0.4),
        ])
    }

    private static func tentaclePath(_ x: CGFloat, _ h: CGFloat) -> Path {
        roundedBoxPath(x, TENTACLE.y, TENTACLE.w, h, [
            (0.4, 0.18),
            (0.4, 0.18),
            (0.5, 0.82),
            (0.5, 0.82),
        ])
    }
}

#if DEBUG
#Preview("Octopus — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        OctopusBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#F4AE9D"))
}
#endif
