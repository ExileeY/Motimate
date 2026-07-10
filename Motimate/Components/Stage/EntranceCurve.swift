import CoreGraphics

struct EntranceFrame: Equatable {
    let opacity: CGFloat
    let scale: CGFloat
    let offsetY: CGFloat
}

private struct Keyframe {
    let position: CGFloat // 0…1 along the timeline
    let opacity: CGFloat
    let scale: CGFloat
    let offsetY: CGFloat

    var frame: EntranceFrame {
        EntranceFrame(
            opacity: opacity,
            scale: scale,
            offsetY: offsetY
        )
    }
}

enum EntranceCurve {
    static let durationMs: Double = 1_250

    static func frame(at progress: CGFloat) -> EntranceFrame {
        interpolatedFrame(at: MathUtils.easeOut(progress))
    }

    private static let keyframes: [Keyframe] = [
        Keyframe(
            position: 0,
            opacity: 0,
            scale: 0.7,
            offsetY: 26
        ),
        Keyframe(
            position: 0.4,
            opacity: 1,
            scale: 0.9,
            offsetY: 6
        ),
        Keyframe(
            position: 0.7,
            opacity: 1,
            scale: 1.05,
            offsetY: -3
        ),
        Keyframe(
            position: 1,
            opacity: 1,
            scale: 1,
            offsetY: 0
        ),
    ]

    private static func interpolatedFrame(at time: CGFloat) -> EntranceFrame {
        guard let fKeyFrame = keyframes.first, let lKeyFrame = keyframes.last else {
            return EntranceFrame(
                opacity: 1,
                scale: 1,
                offsetY: 0
            )
        }

        if time <= fKeyFrame.position { return fKeyFrame.frame }
        if time >= lKeyFrame.position { return lKeyFrame.frame }

        for index in 1..<keyframes.count {
            let start = keyframes[index - 1]
            let end = keyframes[index]

            guard time <= end.position else { continue }

            let segmentLength = end.position - start.position
            let segmentBlend = segmentLength > 0 ? (time - start.position) / segmentLength : 0

            return EntranceFrame(
                opacity: MathUtils.linearInterpolate(
                    start.opacity,
                    end.opacity,
                    segmentBlend
                ),
                scale: MathUtils.linearInterpolate(
                    start.scale,
                    end.scale,
                    segmentBlend
                ),
                offsetY: MathUtils.linearInterpolate(
                    start.offsetY,
                    end.offsetY,
                    segmentBlend
                )
            )
        }

        fatalError("EntranceCurve: no keyframe segment bracketed time \(time)")
    }
}
