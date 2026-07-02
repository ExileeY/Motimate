import CoreGraphics

struct GlowTransform: Equatable {
    let scale: CGFloat
    let center: CGPoint
    let translation: CGSize
}

enum GlowMath {
    static func linearInterpolate(
        _ min: CGFloat,
        _ max: CGFloat,
        _ progress: CGFloat
    ) -> CGFloat {
        min + (max - min) * progress
    }

    static func calcTriangleOpacity(
        progress: CGFloat,
        fadeIn: CGFloat
    ) -> CGFloat {
        progress < fadeIn
            ? progress / fadeIn
            : 1 - (progress - fadeIn) / (1 - fadeIn)
    }

    static func calcTransform(
        scale: CGFloat,
        cx: CGFloat,
        cy: CGFloat,
        tx: CGFloat = 0,
        ty: CGFloat = 0
    ) -> GlowTransform {
        GlowTransform(
            scale: scale,
            center: CGPoint(x: cx, y: cy),
            translation: CGSize(width: tx, height: ty)
        )
    }
}
