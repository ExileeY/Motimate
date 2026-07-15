import SwiftUI

struct WardrobeView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel
    @EnvironmentObject private var accessories: AccessoryStore
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    private var theme: Theme {
        settings.resolvedTheme(isDark: colorScheme == .dark)
    }

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )

    var body: some View {
        let palette = ThemeTokens.for(theme).palette
        let slots = WardrobeGrouping.populatedSlots()

        return PhoneCanvas(mood: .calm) {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(
                    palette: palette,
                    title: "Collection",
                    onBack: goBack
                ) {
                    PillBadge(
                        text: ownedCountLabel,
                        dotColor: palette.accent,
                        palette: palette,
                        dotSize: 7,
                        font: Fonts.bodyBold(11.5),
                        spacing: 6,
                        horizontalPadding: 10
                    )
                }
                .padding(.bottom, 24)

                Text("Walk daily to unlock")
                    .font(Fonts.bodyRegular(13))
                    .foregroundColor(palette.subtitle)
                    .padding(.bottom, 4)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(slots.enumerated()), id: \.element) { index, slot in
                            slotSection(slot, palette)
                                .padding(.top, index == 0 ? 20 : 32)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .environment(\.theme, theme)
        .navigationBarHidden(true)
        .enableInteractiveSwipeBack()
    }

    // MARK: - Sections

    private func slotSection(_ slot: AccessorySlot, _ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel(slot.displayTitle, palette)
                .padding(.bottom, 14)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(WardrobeGrouping.accessoryIds(in: slot), id: \.self) { id in
                    WardrobeTile(
                        name: Accessory.define(id).name,
                        accessoryId: id,
                        isOwned: accessories.isOwned(id),
                        isEquipped: accessories.isEquipped(id),
                        onToggle: { toggleEquip(id) }
                    )
                }
            }
        }
    }

    private func sectionLabel(_ text: String, _ palette: Palette) -> some View {
        Text(text)
            .font(Fonts.bodyBold(12.5))
            .kerning(0.5)
            .textCase(.uppercase)
            .foregroundColor(palette.cardMeta)
    }

    // MARK: - Derived state

    private var ownedCountLabel: String {
        WardrobeGrouping.ownedStatusString(
            owned: accessories.owned.count,
            total: AccessoryId.allCases.count
        )
    }

    // MARK: - Actions

    private func toggleEquip(_ id: AccessoryId) {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)

        if accessories.isEquipped(id) {
            accessories.unequip(id)
        } else {
            accessories.equip(id)
        }
    }

    private func goBack() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
        isPresented = false
    }
}

#if DEBUG
#Preview("Wardrobe") {
    let settings = SettingsStore()
    let accessories = AccessoryStore()

    Accessory.ids.forEach { accessories.unlock($0) }

    return NavigationView {
        WardrobeView(isPresented: .constant(true))
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
    .environmentObject(DailyStepsModel(settings: settings))
    .environmentObject(accessories)
}
#endif
