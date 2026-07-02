import SwiftUI

@main
struct MotimateApp: App {
    @StateObject private var settings: SettingsStore
    @StateObject private var dailySteps: DailyStepsModel

    init() {
        let store = SettingsStore()
        _settings = StateObject(wrappedValue: store)
        _dailySteps = StateObject(wrappedValue: DailyStepsModel(settings: store))
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(.stack)
            .environmentObject(settings)
            .environmentObject(dailySteps)
        }
    }
}
