import SwiftUI

struct PodiumView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel
    @EnvironmentObject private var accessories: AccessoryStore
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    /// Local, non-persisting preview override. Only affects this screen.
    @State private var preview: AccessoryId? = nil

    /// The single accessory featured in v1.
    private let focus: AccessoryId = .coolShades

    private var theme: Theme {
        settings.resolvedTheme(isDark: colorScheme == .dark)
    }

    /// The accessories rendered on the podium pet. Inside Podium, a live `preview` wins for
    /// the featured accessory — it replaces whatever fills that accessory's slot, leaving
    /// the pet's other equipped slots intact.
    private var shownAccessories: [AccessoryId] {
        guard let preview else { return accessories.equippedList }
        let previewSlot = accessoryDefinition(preview).slot
        return accessories.equippedList.filter {
            accessoryDefinition($0).slot != previewSlot
        } + [preview]
    }

    var body: some View {
        let palette = ThemeTokens.for(theme).palette
        let definition = accessoryDefinition(focus)
        let owned = accessories.isOwned(focus)

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
                        owned: owned,
                        equipped: accessories.isEquipped(focus),
                        previewing: preview == focus,
                        steps: dailySteps.steps,
                        goal: definition.stepGoal,
                        progress: accessories.progress(focus, steps: dailySteps.steps),
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

    // MARK: - Header

    private func header(_ palette: Palette) -> some View {
        HStack(spacing: 10) {
            Button(action: goBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(palette.text)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back")

            Text("Podium")
                .font(Fonts.heading(24))
                .foregroundColor(palette.text)

            Spacer()

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
    }

    // MARK: - Actions

    private func togglePreview() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
        preview = (preview == focus) ? nil : focus
    }

    private func toggleEquip() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)

        if accessories.isEquipped(focus) {
            accessories.unequip(focus)
        } else {
            accessories.equip(focus)
            preview = nil
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
