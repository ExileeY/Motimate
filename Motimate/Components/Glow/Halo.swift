import SwiftUI

private enum HaloOpacity {
    static let min: CGFloat = 0.82
    static let max: CGFloat = 1
}

private enum HaloScale {
    static let min: CGFloat = 1
    static let max: CGFloat = 1.07
}

struct Halo: View {
    let mood: Mood
    let size: CGFloat

    var body: some View {
        let spec = glow[mood]!
        let center = size / 2
        let radius = (spec.size / PET_SIZE) * (size / 2)

        PingPongLoop(durationMs: spec.pulseDuration) { progress in
            let progress = CGFloat(progress)
            let scale = MathUtils.linearInterpolate(
                HaloScale.min,
                HaloScale.max,
                progress
            )
            let opacity = MathUtils.linearInterpolate(
                HaloOpacity.min,
                HaloOpacity.max,
                progress
            )

            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(
                                color: spec.color.opacity(spec.opacity),
                                location: 0
                            ),
                            Gradient.Stop(
                                color: spec.color.opacity(0),
                                location: 0.68
                            ),
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: radius
                    )
                )
                .frame(width: radius * 2, height: radius * 2)
                .blur(radius: 4)
                .opacity(opacity)
                .scaleEffect(scale)
                .position(x: center, y: center)
        }
        .frame(width: size, height: size)
    }
}

#if DEBUG
#Preview("Halo") {
    VStack(spacing: 16) {
        ForEach(Mood.allCases, id: \.self) { mood in
            Halo(
                mood: mood,
                size: BOX_SIZE
            )
            .background(screenBackground[mood]!.colors[1])
        }
    }
    .padding()
}
#endif
