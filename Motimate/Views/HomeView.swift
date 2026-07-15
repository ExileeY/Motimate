import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel
    @EnvironmentObject private var celebration: CelebrationStore
    @EnvironmentObject private var accessories: AccessoryStore
    @EnvironmentObject private var weeklyChallenge: WeeklyChallengeModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.scenePhase) private var scenePhase

    @State private var messages: [Mood: MessageSet] = [:]

    @State private var showSettings = false
    @State private var showPodium = false
    @State private var showWardrobe = false

    @State private var isCelebrating = false

    private static var isEntrancePlayed = false // process-lifetime state, survives view remounts
    @State private var shouldPlayEntrance = false

    #if DEBUG
    // Dev-only: tap the pet to preview each mood without walking.
    @State private var override: Mood? = nil
    private let moodCycle: [Mood] = [.energetic, .calm, .tired, .sad]
    #endif

    private var theme: Theme {
        settings.resolvedTheme(isDark: colorScheme == .dark)
    }

    var body: some View {
        GeometryReader { geo in
            let mood = displayMood

            Group {
                if dailySteps.loading {
                    bootScreen
                } else {
                    screen(mood: mood, height: geo.size.height)
                }
            }
            .overlay(celebrationOverlay)
        }
        .environment(\.theme, theme)
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                isActive: $showSettings,
                destination: { SettingsView(isPresented: $showSettings) },
                label: { EmptyView() }
            )
            .hidden()
        )
        .background(
            NavigationLink(
                isActive: $showPodium,
                destination: { PodiumView(isPresented: $showPodium) },
                label: { EmptyView() }
            )
            .hidden()
        )
        .background(
            NavigationLink(
                isActive: $showWardrobe,
                destination: { WardrobeView(isPresented: $showWardrobe) },
                label: { EmptyView() }
            )
            .hidden()
        )
        .onAppear {
            dailySteps.start()
            weeklyChallenge.start()
            refreshMessages()
            triggerEntrance()
            maybeCelebrate()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                dailySteps.refresh()
                weeklyChallenge.refresh()
            }
        }
        .onChange(of: settings.petId) { _ in
            refreshMessages()
        }
        .onChange(of: dailySteps.progress) { _ in
            maybeCelebrate()
        }
        .onChange(of: dailySteps.loading) { _ in
            maybeCelebrate()
        }
    }

    // MARK: - Celebration overlay

    @ViewBuilder
    private var celebrationOverlay: some View {
        if isCelebrating {
            Confetti(onFinished: { isCelebrating = false })
                .ignoresSafeArea()
        }
    }

    // MARK: - Boot screen

    private var bootScreen: some View {
        let palette = ThemeTokens.for(theme).palette
        let bootBg = ThemeTokens.for(theme).screenBackground(.calm).colors[1]

        return ZStack {
            bootBg
                .ignoresSafeArea()

            ProgressView()
                .tint(palette.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Main screen

    private func screen(mood: Mood, height: CGFloat) -> some View {
        let scale = computeScale(height)
        let message = messages[mood] ?? fallbackMessage
        let hasLiveSteps = dailySteps.permission == .granted && dailySteps.error == nil
        let palette = ThemeTokens.for(theme).palette

        return PhoneCanvas(mood: mood) {
            VStack(spacing: 0) {
                TopBar(
                    mood: mood,
                    onSettingsTap: {
                        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
                        showSettings = true
                    },
                    onPodiumTap: {
                        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
                        showPodium = true
                    },
                    onWardrobeTap: {
                        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
                        showWardrobe = true
                    }
                )

                Spacer(minLength: 0)

                petArea(mood: mood, height: height)

                Spacer(minLength: 0)

                VStack(spacing: 6) {
                    Text(message.headline)
                        .font(Fonts.heading((30 * scale).rounded()))
                        .foregroundColor(palette.text)
                        .multilineTextAlignment(.center)

                    Text(message.subtitle)
                        .font(Fonts.bodyRegular(((14.5 * scale) * 10).rounded() / 10))
                        .foregroundColor(palette.subtitle)
                        .multilineTextAlignment(.center)
                }

                MovementCard(
                    message: message,
                    steps: dailySteps.steps,
                    progress: dailySteps.progress,
                    hasLiveSteps: hasLiveSteps
                )
                .padding(.top, 18)

                if let notice = notice {
                    Text(notice)
                        .font(Fonts.bodyRegular(12))
                        .foregroundColor(palette.cardMeta)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
            }
        }
    }

    private func petArea(mood: Mood, height: CGFloat) -> some View {
        let stage = PetStage(
            mood: mood,
            petId: settings.petId,
            screenHeight: height,
            accessories: accessories.equippedList,
            entrance: EntranceMotionParams(
                active: shouldPlayEntrance,
                onFinished: { shouldPlayEntrance = false }
            )
        )

        #if DEBUG
        return stage
            .contentShape(Rectangle())
            .onTapGesture(perform: cycleMood)
            .onLongPressGesture(perform: toggleTheme)
        #else
        return stage
        #endif
    }

    // MARK: - Derived state

    private var displayMood: Mood {
        #if DEBUG
        return override ?? dailySteps.mood
        #else
        return dailySteps.mood
        #endif
    }

    private var notice: String? {
        switch dailySteps.permission {
        case .unavailable:
            return "Movement data unavailable on this device."
        case .denied:
            return "Motion access off — showing a resting state."
        default:
            return dailySteps.error
        }
    }

    private var fallbackMessage: MessageSet {
        MessageSet(headline: "", subtitle: "", meta: "", footer: "")
    }

    // MARK: - Actions

    private func refreshMessages() {
        messages = petDefinition(settings.petId).pickMessages()
    }

    private func triggerEntrance() {
        if !Self.isEntrancePlayed {
            Self.isEntrancePlayed = true
            shouldPlayEntrance = true
        }
    }

    private func maybeCelebrate() {
        guard !dailySteps.loading else { return }
        guard dailySteps.progress >= 1 else { return }
        guard celebration.shouldCelebrate() else { return }

        celebration.markCelebrated()
        isCelebrating = true
        HapticsService.celebration(enabled: settings.hapticsAnimationEnabled)
    }

    #if DEBUG
    private func cycleMood() {
        let current = override ?? dailySteps.mood
        let next = (moodCycle.firstIndex(of: current) ?? -1) + 1
        override = moodCycle[next % moodCycle.count]

        // Replay the confetti (so the animation haptic is testable without walking)
        celebration.resetToday()
        isCelebrating = false
        DispatchQueue.main.async {
            isCelebrating = true
            HapticsService.celebration(enabled: settings.hapticsAnimationEnabled)
        }
    }

    private func toggleTheme() {
        switch settings.themeOverride {
        case nil: settings.themeOverride = .night
        case .night: settings.themeOverride = .day
        case .day: settings.themeOverride = nil
        }
    }
    #endif
}

#if DEBUG
#Preview {
    let settings = SettingsStore()
    let dailySteps = DailyStepsModel(settings: settings)
    let accessories = AccessoryStore()

    return NavigationView {
        HomeView()
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
    .environmentObject(dailySteps)
    .environmentObject(CelebrationStore())
    .environmentObject(accessories)
    .environmentObject(WeeklyChallengeModel(accessories: accessories, dailySteps: dailySteps))
}
#endif
