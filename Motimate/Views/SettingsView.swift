import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    @State private var draft: String = ""
    @FocusState private var goalFocused: Bool

    private var theme: Theme {
        settings.resolvedTheme(isDark: colorScheme == .dark)
    }

    var body: some View {
        let palette = ThemeTokens.for(theme).palette

        return PhoneCanvas(mood: .calm) {
            VStack(alignment: .leading, spacing: 0) {
                ScreenHeader(
                    palette: palette,
                    title: "Settings",
                    onBack: goBack
                )
                .padding(.bottom, 28)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        goalSection(palette)
                        modeSection(palette)
                        petSection(palette)
                        nightSection(palette)
                        hapticsSection(palette)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .environment(\.theme, theme)
        .navigationBarHidden(true)
        .enableInteractiveSwipeBack()
        .onAppear { draft = String(settings.goal) }
        .onDisappear { commitGoal() }
        .onChange(of: goalFocused) { focused in
            if !focused { commitGoal() }
        }
    }

    // MARK: - Sections

    private func goalSection(_ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("User goals", palette)
                .padding(.bottom, 10)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Steps")
                        .font(Fonts.headingMedium(17))
                        .foregroundColor(palette.text)
                    Text("Your daily movement objective")
                        .font(Fonts.bodyRegular(13))
                        .foregroundColor(palette.subtitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                TextField("", text: $draft)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .font(Fonts.bodyBold(17))
                    .foregroundColor(palette.text)
                    .focused($goalFocused)
                    .frame(minWidth: 92)
                    .overlay(alignment: .trailing) {
                        if draft.isEmpty {
                            Text(String(GoalStorage.defaultValue))
                                .font(Fonts.bodyBold(17))
                                .foregroundColor(palette.subtitle)
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(palette.pillBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(palette.pillBorder, lineWidth: 1)
                    )
                    .onChange(of: draft) { value in
                        // Digits only, max 6 (mirrors number-pad + maxLength=6).
                        let filtered = String(value.filter(\.isNumber).prefix(6))
                        if filtered != value { draft = filtered }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") { goalFocused = false }
                        }
                    }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background(palette.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(palette.cardBorder, lineWidth: 1)
            )

            Text("Between \(NumberFormat.grouped(GoalStorage.minValue)) and \(NumberFormat.grouped(GoalStorage.maxValue)) steps.")
                .font(Fonts.bodyRegular(12))
                .foregroundColor(palette.cardMeta)
                .padding(.top, 10)
                .padding(.leading, 4)
        }
    }

    private func modeSection(_ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Mode", palette)
                .padding(.bottom, 5)
            Text("How real do you want it?")
                .font(Fonts.heading(24))
                .foregroundColor(palette.text)
            Text("Choose what happens to your pet between walks.")
                .font(Fonts.bodyRegular(13))
                .foregroundColor(palette.subtitle)
                .padding(.top, 6)

            ModePicker()
                .padding(.top, 16)
        }
        .padding(.top, 32)
    }

    private func petSection(_ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Pet", palette)
                .padding(.bottom, 5)
            Text("Choose your companion")
                .font(Fonts.heading(24))
                .foregroundColor(palette.text)
            Text("Lives on your home screen. Switch any time.")
                .font(Fonts.bodyRegular(13))
                .foregroundColor(palette.subtitle)
                .padding(.top, 6)

            PetPicker()
                .padding(.top, 16)
        }
        .padding(.top, 32)
    }

    private func nightSection(_ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Appearance", palette)
                .padding(.bottom, 5)
            Text("Night theme")
                .font(Fonts.heading(24))
                .foregroundColor(palette.text)
            Text("Switch to a dark look when your device is in Dark Mode.")
                .font(Fonts.bodyRegular(13))
                .foregroundColor(palette.subtitle)
                .padding(.top, 6)

            Toggle(isOn: autoNightBinding) {
                Text("Follow system appearance")
                    .font(Fonts.headingMedium(16.5))
                    .foregroundColor(palette.text)
            }
            .hapticSwitch(enabled: settings.hapticsTabEnabled, tint: palette.accent)
            .padding(.vertical, 15)
            .padding(.horizontal, 15)
            .background(palette.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(palette.cardBorder, lineWidth: 1.5)
            )
            .padding(.top, 16)
        }
        .padding(.top, 32)
    }

    private func hapticsSection(_ palette: Palette) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Feedback", palette)
                .padding(.bottom, 5)
            Text("Haptics")
                .font(Fonts.heading(24))
                .foregroundColor(palette.text)
            Text("Add subtle vibrations to taps and celebrations.")
                .font(Fonts.bodyRegular(13))
                .foregroundColor(palette.subtitle)
                .padding(.top, 6)

            hapticToggleRow(
                "Vibrate on taps",
                isOn: tapHapticsBinding,
                palette
            )
                .padding(.top, 16)
            hapticToggleRow(
                "Vibrate on animations",
                isOn: animationHapticsBinding,
                palette
            )
                .padding(.top, 12)
        }
        .padding(.top, 32)
    }

    private func hapticToggleRow(_ label: String, isOn: Binding<Bool>, _ palette: Palette) -> some View {
        Toggle(isOn: isOn) {
            Text(label)
                .font(Fonts.headingMedium(16.5))
                .foregroundColor(palette.text)
        }
        .hapticSwitch(enabled: settings.hapticsTabEnabled, tint: palette.accent)
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .background(palette.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(palette.cardBorder, lineWidth: 1.5)
        )
    }

    // MARK: - Helpers

    private var autoNightBinding: Binding<Bool> {
        Binding(
            get: { settings.autoNightEnabled },
            set: { settings.setAutoNight($0) }
        )
    }

    private var tapHapticsBinding: Binding<Bool> {
        Binding(
            get: { settings.hapticsTabEnabled },
            set: { settings.setHapticsTap($0) }
        )
    }

    private var animationHapticsBinding: Binding<Bool> {
        Binding(
            get: { settings.hapticsAnimationEnabled },
            set: { settings.setHapticsAnimation($0) }
        )
    }

    private func sectionLabel(_ text: String, _ palette: Palette) -> some View {
        Text(text)
            .font(Fonts.bodyBold(12.5))
            .kerning(0.5)
            .textCase(.uppercase)
            .foregroundColor(palette.cardMeta)
    }

    // MARK: - Actions

    private func commitGoal() {
        let trimmed = draft.trimmingCharacters(in: .whitespaces)
        let parsed = trimmed.isEmpty ? GoalStorage.defaultValue : (Int(trimmed) ?? GoalStorage.defaultValue)
        draft = String(settings.setGoal(parsed))
    }

    private func goBack() {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)
        commitGoal()
        isPresented = false
    }
}

#if DEBUG
#Preview("Settings") {
    let settings = SettingsStore()
    return NavigationView {
        SettingsView(isPresented: .constant(true))
    }
    .navigationViewStyle(.stack)
    .environmentObject(settings)
}
#endif
