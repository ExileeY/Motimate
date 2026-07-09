import CoreGraphics

enum MathUtils {
    static func clamp<T: Comparable>(_ value: T, min lower: T, max upper: T) -> T {
        Swift.min(Swift.max(value, lower), upper)
    }

    static func clamp01<T: Comparable & FloatingPoint>(_ value: T) -> T {
        clamp(value, min: 0, max: 1)
    }

    // Quadratic ease-out: 1 - (1 - t)^2
    static func easeOut(_ progress: CGFloat) -> CGFloat {
        let clamped = clamp01(progress)
        return 1 - (1 - clamped) * (1 - clamped)
    }

    // Smoothstep ease-in-out: t^2 * (3 - 2t)
    static func easeInOut(_ progress: Double) -> Double {
        let clamped = clamp01(progress)
        return clamped * clamped * (3 - 2 * clamped)
    }

    static func linearInterpolate(
        _ min: CGFloat,
        _ max: CGFloat,
        _ progress: CGFloat
    ) -> CGFloat {
        min + (max - min) * progress
    }
}
