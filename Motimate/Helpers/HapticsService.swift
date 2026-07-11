import UIKit

enum HapticsService {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light, enabled: Bool) {
        guard enabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func celebration(enabled: Bool) {
        guard enabled else { return }

        // (delayMs, style) — a rising then fading roll over ~0.75s.
        let pattern: [(Double, UIImpactFeedbackGenerator.FeedbackStyle)] = [
            (0, .light),
            (90, .medium),
            (180, .heavy),
            (300, .heavy),
            (430, .medium),
            (580, .light),
            (740, .light),
        ]

        for (delayMs, style) in pattern {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMs / 1000) {
                generator.impactOccurred()
            }
        }
    }
}
