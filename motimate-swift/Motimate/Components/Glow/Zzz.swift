import SwiftUI

private enum ZMotion {
    static let translateXMin: CGFloat = 0
    static let translateXMax: CGFloat = 16
    static let translateYMin: CGFloat = 8
    static let translateYMax: CGFloat = -30
    static let scaleMin: CGFloat = 0.7
    static let scaleMax: CGFloat = 1.15
    static let fadeIn: CGFloat = 0.25
    static let durationMs: Double = 3_400
}

private let zzzPosition = CGPoint(
    x: ((BOX_SIZE - PET_SIZE) / 2) + 160,
    y: ((BOX_SIZE - PET_SIZE) / 2) + 20
)

private struct ZSpec: Identifiable {
    let id: Int
    let label: String
    let offsetX: CGFloat
    let fontSize: CGFloat
    let delayMs: Double
}

private let zSpecs = [
    ZSpec(
        id: 0,
        label: "z",
        offsetX: 0,
        fontSize: 20,
        delayMs: 0
    ),
    ZSpec(
        id: 1,
        label: "z",
        offsetX: 15,
        fontSize: 25,
        delayMs: 1_100
    ),
    ZSpec(
        id: 2,
        label: "Z",
        offsetX: 30,
        fontSize: 30,
        delayMs: 2_200
    ),
]

struct Zzz: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            ForEach(zSpecs) { spec in
                ZGlyph(
                    spec: spec,
                    stageScale: size / BOX_SIZE
                )
            }
        }
        .frame(width: size, height: size)
    }
}

private struct ZGlyph: View {
    let spec: ZSpec
    let stageScale: CGFloat

    var body: some View {
        let centerX = (zzzPosition.x + spec.offsetX) * stageScale
        let centerY = (zzzPosition.y + spec.fontSize) * stageScale

        RiseLoop(
            durationMs: ZMotion.durationMs,
            delayMs: spec.delayMs
        ) { progress in
            let progress = CGFloat(progress)
            let scale = GlowMath.linearInterpolate(
                ZMotion.scaleMin,
                ZMotion.scaleMax,
                progress
            )
            let translateX = GlowMath.linearInterpolate(
                ZMotion.translateXMin,
                ZMotion.translateXMax,
                progress
            )
            let translateY = GlowMath.linearInterpolate(
                ZMotion.translateYMin,
                ZMotion.translateYMax,
                progress
            )
            let opacity = GlowMath.calcTriangleOpacity(
                progress: progress,
                fadeIn: ZMotion.fadeIn
            )
            let transform = GlowMath.calcTransform(
                scale: scale,
                cx: centerX,
                cy: centerY,
                tx: translateX * stageScale,
                ty: translateY * stageScale
            )

            Text(spec.label)
                .font(Fonts.heading(spec.fontSize * stageScale))
                .foregroundColor(Color(hex: "#A9794F"))
                .scaleEffect(transform.scale)
                .opacity(opacity)
                .position(
                    x: transform.center.x + transform.translation.width,
                    y: transform.center.y + transform.translation.height
                )
        }
    }
}

#if DEBUG
#Preview("Zzz") {
    Zzz(size: BOX_SIZE)
        .background(screenBackground[.tired]!.colors[1])
        .padding()
}
#endif
