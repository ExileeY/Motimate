import SwiftUI

struct PodiumView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel
    @EnvironmentObject private var accessories: AccessoryStore
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    @State private var previewAccessory: AccessoryId? = nil
    private let podiumAccessory: AccessoryId = .babyMochi

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
        let definition = Accessory.define(podiumAccessory)

        return GeometryReader { geo in
            PhoneCanvas(mood: .calm) {
                VStack(spacing: 0) {
                    ScreenHeader(
                        palette: palette,
                        title: "Podium",
                        onBack: goBack
                    ) {
                        PillBadge(
                            text: NumberFormat.grouped(dailySteps.steps),
                            dotColor: palette.accent,
                            palette: palette,
                            dotSize: 7,
                            font: Fonts.bodyBold(11.5),
                            spacing: 6,
                            horizontalPadding: 10
                        )
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

                    AccessoryCard(
                        name: definition.name,
                        petName: petDefinition(settings.petId).name,
                        accessoryId: podiumAccessory,
                        isOwned: accessories.isOwned(podiumAccessory),
                        isEquipped: accessories.isEquipped(podiumAccessory),
                        isPreviewing: isPreviewing(),
                        steps: dailySteps.steps,
                        goal: definition.stepGoal,
                        progress: accessories.progress(podiumAccessory, steps: dailySteps.steps),
                        onEquip: toggleEquip,
                        onPreview: togglePreview
                    )
                    .padding(.top, 16)
                }
            }
        }
        .environment(\.theme, theme)
        .navigationBarHidden(true)
        .enableInteractiveSwipeBack()
    }

    private func isPreviewing() -> Bool {
        previewAccessory == podiumAccessory
    }

    // MARK: - Actions

    private func togglePreview() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
        previewAccessory = isPreviewing() ? nil : podiumAccessory
    }

    private func toggleEquip() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)

        if accessories.isEquipped(podiumAccessory) {
            accessories.unequip(podiumAccessory)
        } else {
            accessories.equip(podiumAccessory)
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
    return NavigationView {
        PodiumView(isPresented: .constant(true))
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
    .environmentObject(DailyStepsModel(settings: settings))
    .environmentObject(AccessoryStore())
}
#endif
