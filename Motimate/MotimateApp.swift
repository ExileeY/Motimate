import SwiftUI

@main
struct MotimateApp: App {
    @StateObject private var dailySteps: DailyStepsModel
    @StateObject private var weeklyChallenge: WeeklyChallengeModel

    @StateObject private var settings: SettingsStore
    @StateObject private var celebration = CelebrationStore()
    @StateObject private var accessories: AccessoryStore

    init() {
        let settingsStore = SettingsStore()
        let accessoryStore = AccessoryStore()
        let steps = DailyStepsModel(settings: settingsStore)
        let weekly = WeeklyChallengeModel(accessories: accessoryStore, dailySteps: steps)

        _settings = StateObject(wrappedValue: settingsStore)
        _accessories = StateObject(wrappedValue: accessoryStore)
        _dailySteps = StateObject(wrappedValue: steps)
        _weeklyChallenge = StateObject(wrappedValue: weekly)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(.stack)
            .environmentObject(settings)
            .environmentObject(dailySteps)
            .environmentObject(celebration)
            .environmentObject(accessories)
            .environmentObject(weeklyChallenge)
        }
    }
}
