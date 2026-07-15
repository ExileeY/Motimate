import SwiftUI

struct PodiumView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel
    @EnvironmentObject private var accessories: AccessoryStore
    @EnvironmentObject private var weeklyChallenge: WeeklyChallengeModel
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    @State private var previewAccessory: AccessoryId? = nil

    private var theme: Theme {
        settings.resolvedTheme(isDark: colorScheme == .dark)
    }

    private var shownAccessories: [AccessoryId] {
        guard let previewAccessory else { return accessories.equippedList }

        return accessories.equippedList.filter {
            Accessory.define($0).slot != Accessory.define(previewAccessory).slot
        } + [previewAccessory]
    }

    var body: some View {
        let palette = ThemeTokens.for(theme).palette

        return GeometryReader { geo in
            PhoneCanvas(mood: .calm) {
                VStack(spacing: 0) {
                    ScreenHeader(
                        palette: palette,
                        title: "Podium",
                        onBack: goBack
                    ) {
                        stepBadge(palette)
                    }
                    .padding(.bottom, 28)

                    Spacer(minLength: 0)

                    PodiumStage(
                        mood: dailySteps.mood,
                        petId: settings.petId,
                        screenHeight: geo.size.height,
                        accessories: shownAccessories
                    )

                    Spacer(minLength: 0)

                    challengeCard
                        .padding(.top, 16)
                }
            }
        }
        .environment(\.theme, theme)
        .navigationBarHidden(true)
        .enableInteractiveSwipeBack()
        .onAppear { weeklyChallenge.start() }
        .onChange(of: weeklyChallenge.weeklyAccessory) { _ in previewAccessory = nil }
    }

    private func stepBadge(_ palette: Palette) -> some View {
        let badge = PillBadge(
            text: NumberFormat.grouped(weeklyChallenge.weeklySteps),
            dotColor: palette.accent,
            palette: palette,
            dotSize: 7,
            font: Fonts.bodyBold(11.5),
            spacing: 6,
            horizontalPadding: 10
        )

        #if DEBUG
        return badge
            .contentShape(Rectangle())
            .onTapGesture { weeklyChallenge.debugAddWeeklySteps(10_000) }
            .onLongPressGesture { weeklyChallenge.debugAdvanceWeek() }
        #else
        return badge
        #endif
    }

    @ViewBuilder
    private var challengeCard: some View {
        if let accessory = weeklyChallenge.weeklyAccessory {
            let definition = Accessory.define(accessory)

            AccessoryCard(
                name: definition.name,
                petName: petDefinition(settings.petId).name,
                accessoryId: accessory,
                isOwned: accessories.isOwned(accessory),
                isEquipped: accessories.isEquipped(accessory),
                isPreviewing: isPreviewing(accessory),
                steps: weeklyChallenge.weeklySteps,
                goal: definition.weeklyStepGoal,
                progress: accessories.progress(accessory, steps: weeklyChallenge.weeklySteps),
                onEquip: { toggleEquip(accessory) },
                onPreview: { togglePreview(accessory) }
            )
        } else {
            WeeklyPlaceholderCard()
        }
    }

    private func isPreviewing(_ id: AccessoryId) -> Bool {
        previewAccessory == id
    }

    // MARK: - Actions

    private func togglePreview(_ id: AccessoryId) {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
        previewAccessory = isPreviewing(id) ? nil : id
    }

    private func toggleEquip(_ id: AccessoryId) {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)

        if accessories.isEquipped(id) {
            accessories.unequip(id)
        } else {
            accessories.equip(id)
            previewAccessory = nil
        }
    }

    private func goBack() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
        isPresented = false
    }
}

#if DEBUG
#Preview("Podium") {
    let settings = SettingsStore()
    let dailySteps = DailyStepsModel(settings: settings)
    let accessories = AccessoryStore()

    return NavigationView {
        PodiumView(isPresented: .constant(true))
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
    .environmentObject(dailySteps)
    .environmentObject(accessories)
    .environmentObject(WeeklyChallengeModel(accessories: accessories, dailySteps: dailySteps))
}
#endif
