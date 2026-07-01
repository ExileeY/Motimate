import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel

    @State private var messages: [Mood: MessageSet] = [:]

    @State private var showSettings = false

    #if DEBUG
    // Dev-only: tap the pet to preview each mood without walking.
    @State private var override: Mood? = nil
    private let moodCycle: [Mood] = [.energetic, .calm, .tired, .sad]
    #endif

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
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                isActive: $showSettings,
                destination: { SettingsView(isPresented: $showSettings) },
                label: { EmptyView() }
            )
            .hidden()
        )
        .onAppear {
            dailySteps.start()
            refreshMessages()
        }
        .onChange(of: settings.petId) { _ in
            refreshMessages()
        }
    }

    // MARK: - Boot

    private var bootScreen: some View {
        ZStack {
            Color(hex: "#F6E4D0")
                .ignoresSafeArea()

            ProgressView()
                .tint(Colors.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Assembled screen

    private func screen(mood: Mood, height: CGFloat) -> some View {
        let scale = computeScale(height)
        let message = messages[mood] ?? fallbackMessage
        let hasLiveSteps = dailySteps.permission == .granted && dailySteps.error == nil

        return PhoneCanvas(mood: mood) {
            VStack(spacing: 0) {
                TopBar(mood: mood, onSettingsTap: { showSettings = true })

                Spacer(minLength: 0)

                petArea(mood: mood, height: height)

                Spacer(minLength: 0)

                VStack(spacing: 6) {
                    Text(message.headline)
                        .font(Fonts.heading((30 * scale).rounded()))
                        .foregroundColor(Colors.text)
                        .multilineTextAlignment(.center)

                    Text(message.subtitle)
                        .font(Fonts.bodyRegular(((14.5 * scale) * 10).rounded() / 10))
                        .foregroundColor(Colors.subtitle)
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
                        .foregroundColor(Colors.cardMeta)
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
            screenHeight: height
        )

        #if DEBUG
        return stage
            .contentShape(Rectangle())
            .onTapGesture(perform: cycleMood)
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

    #if DEBUG
    private func cycleMood() {
        let current = override ?? dailySteps.mood
        let next = (moodCycle.firstIndex(of: current) ?? -1) + 1
        override = moodCycle[next % moodCycle.count]
    }
    #endif
}

#if DEBUG
#Preview {
    let settings = SettingsStore()
    return NavigationView {
        HomeView()
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
    .environmentObject(DailyStepsModel(settings: settings))
}
#endif
