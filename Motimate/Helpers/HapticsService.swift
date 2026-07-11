import UIKit

/// Fires light haptic feedback, gated on the caller-supplied enabled flag so it
/// stays a pure entry point. Callers pass `SettingsStore.hapticsEnabled`.
enum HapticsService {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light, enabled: Bool) {
        guard enabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
