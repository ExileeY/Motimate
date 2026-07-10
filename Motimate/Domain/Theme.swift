import SwiftUI

enum Theme {
    case day
    case night

    static func resolve(autoNightEnabled: Bool, isDark: Bool) -> Theme {
        autoNightEnabled && isDark ? .night : .day
    }
}

// MARK: - Environment

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .day
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }

    var themeTokens: ThemeTokens { ThemeTokens.for(theme) }
}
