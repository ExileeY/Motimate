import SwiftUI

struct SceneCloudConfig {
    let x: CGFloat // fraction of width
    let y: CGFloat // fraction of height
    let scale: CGFloat
    let alpha: CGFloat
    let drift: CGFloat // horizontal travel, fraction of width
    let durationMs: Double
}

struct SceneClouds: View {
    let configs: [SceneCloudConfig]
    let color: Color
    let area: CGSize

    /// `CloudPuff` is authored in points for a ~390pt-wide screen.
    private static let referenceWidth: CGFloat = 390

    var body: some View {
        let unit = area.width / Self.referenceWidth

        ZStack(alignment: .topLeading) {
            ForEach(Array(configs.enumerated()), id: \.offset) { _, config in
                PingPongLoop(durationMs: config.durationMs) { progress in
                    let dx = (CGFloat(progress) - 0.5) * 2 * config.drift * area.width

                    CloudPuff(color: color, alpha: config.alpha)
                        .scaleEffect(config.scale * unit)
                        .position(x: config.x * area.width + dx, y: config.y * area.height)
                }
            }
        }
        .frame(width: area.width, height: area.height)
    }
}
