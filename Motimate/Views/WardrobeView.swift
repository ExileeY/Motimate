import SwiftUI

struct WardrobeView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var dailySteps: DailyStepsModel
    @EnvironmentObject private var accessories: AccessoryStore
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    @State private var sceneryAwaitingConfirmation: SceneryId? = nil

    private var theme: Theme {
        settings.resolvedTheme(isDark: colorScheme == .dark)
    }

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    private static let petSizeMultiplier: CGFloat = 0.72

    var body: some View {
        let palette = ThemeTokens.for(theme).palette
        let slots = WardrobeGrouping.populatedSlots()

        return GeometryReader { geo in
            PhoneCanvas(mood: .calm) {
                VStack(alignment: .leading, spacing: 0) {
                    ScreenHeader(
                        palette: palette,
                        title: "Wardrobe",
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
                    .padding(.bottom, 20)

                    PetStage(
                        mood: dailySteps.mood,
                        petId: settings.petId,
                        screenHeight: geo.size.height,
                        accessories: accessories.equippedList,
                        sizeMultiplier: Self.petSizeMultiplier
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 12)

                    if !accessories.owned.isEmpty {
                        Text("Tap an item to wear it")
                            .font(Fonts.bodyRegular(13))
                            .foregroundColor(palette.subtitle)
                            .padding(.bottom, 4)
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            scenerySection(palette)
                                .padding(.top, 20)

                            ForEach(slots, id: \.self) { slot in
                                slotSection(slot, palette)
                                    .padding(.top, 32)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .environment(\.theme, theme)
        .navigationBarHidden(true)
        .enableInteractiveSwipeBack()
        .alert(
            "Stop following system appearance?",
            isPresented: confirmingScenery,
            presenting: sceneryAwaitingConfirmation
        ) { id in
            Button("Cancel", role: .cancel) {}
            Button("Use theme") { settings.setScenery(id) }
        } message: { _ in
            Text("Themes have their own look, so Follow system appearance will be turned off. You can turn it back on in Settings.")
        }
    }

    // MARK: - Sections

    private func scenerySection(_ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Themes", palette)
                .padding(.bottom, 14)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(SCENERY_IDS, id: \.self) { id in
                    WardrobeTile(
                        name: sceneryDefinition(id).name,
                        isEquipped: settings.sceneryId == id,
                        onToggle: { selectScenery(id) }
                    ) {
                        sceneryDefinition(id).backdrop(.calm)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
    }

    private func slotSection(_ slot: AccessorySlot, _ palette: Palette) -> some View {
        let ids = WardrobeGrouping.ownedAccessoryIds(in: slot, owned: accessories.owned)

        return VStack(alignment: .leading, spacing: 0) {
            sectionLabel(slot.displayTitle, palette)
                .padding(.bottom, 14)

            if ids.isEmpty {
                WardrobeEmptySlotCard()
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(ids, id: \.self) { id in
                        WardrobeTile(
                            name: Accessory.define(id).name,
                            isEquipped: accessories.isEquipped(id),
                            onToggle: { toggleEquip(id) }
                        ) {
                            Accessory.define(id).view(.calm, WardrobeTile.previewSize, 1)
                        }
                    }
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

    /// SwiftUI writes `false` here when any alert button dismisses it, which clears the pending scenery.
    private var confirmingScenery: Binding<Bool> {
        Binding(
            get: { sceneryAwaitingConfirmation != nil },
            set: { if !$0 { sceneryAwaitingConfirmation = nil } }
        )
    }

    // MARK: - Actions

    private func selectScenery(_ id: SceneryId) {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)

        guard id != settings.sceneryId else { return }

        if settings.shouldConfirmDisablingAutoNight(for: id) {
            sceneryAwaitingConfirmation = id
            return
        }

        settings.setScenery(id)
    }

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
@MainActor
private func wardrobePreview(owned: [AccessoryId]) -> some View {
    let settings = SettingsStore()
    let accessories = AccessoryStore()

    owned.forEach { accessories.unlock($0) }

    return NavigationView {
        WardrobeView(isPresented: .constant(true))
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
    .environmentObject(DailyStepsModel(settings: settings))
    .environmentObject(accessories)
}

#Preview("Wardrobe") {
    wardrobePreview(owned: Accessory.ids)
}

#Preview("Wardrobe — Empty") {
    wardrobePreview(owned: [])
}

#Preview("Wardrobe — One slot owned") {
    wardrobePreview(owned: [.coolShades])
}
#endif
