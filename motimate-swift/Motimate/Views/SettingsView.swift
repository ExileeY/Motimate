import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore

    @Binding var isPresented: Bool

    @State private var draft: String = ""
    @FocusState private var goalFocused: Bool

    var body: some View {
        PhoneCanvas(mood: .calm) {
            VStack(alignment: .leading, spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        goalSection
                        modeSection
                        petSection
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { draft = String(settings.goal) }
        .onChange(of: goalFocused) { focused in
            if !focused { commitGoal() }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 10) {
            Button(action: goBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(Colors.text)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back")

            Text("Settings")
                .font(Fonts.heading(24))
                .foregroundColor(Colors.text)
        }
        .padding(.bottom, 28)
    }

    // MARK: - Sections

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("User goals")
                .padding(.bottom, 10)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Steps")
                        .font(Fonts.headingMedium(17))
                        .foregroundColor(Colors.text)
                    Text("Your daily movement objective")
                        .font(Fonts.bodyRegular(13))
                        .foregroundColor(Colors.subtitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                TextField(String(GOAL_DEFAULT), text: $draft)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .font(Fonts.bodyBold(17))
                    .foregroundColor(Colors.text)
                    .focused($goalFocused)
                    .frame(minWidth: 92)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Colors.pillBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Colors.pillBorder, lineWidth: 1)
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
            .background(Colors.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Colors.cardBorder, lineWidth: 1)
            )

            Text("Between \(formatGoal(GOAL_MIN)) and \(formatGoal(GOAL_MAX)) steps.")
                .font(Fonts.bodyRegular(12))
                .foregroundColor(Colors.cardMeta)
                .padding(.top, 10)
                .padding(.leading, 4)
        }
    }

    private var modeSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Mode")
                .padding(.bottom, 5)
            Text("How real do you want it?")
                .font(Fonts.heading(24))
                .foregroundColor(Colors.text)
            Text("Choose what happens to your pet between walks.")
                .font(Fonts.bodyRegular(13))
                .foregroundColor(Colors.subtitle)
                .padding(.top, 6)

            ModePicker()
                .padding(.top, 16)
        }
        .padding(.top, 32)
    }

    private var petSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("Pet")
                .padding(.bottom, 5)
            Text("Choose your companion")
                .font(Fonts.heading(24))
                .foregroundColor(Colors.text)
            Text("Lives on your home screen. Switch any time.")
                .font(Fonts.bodyRegular(13))
                .foregroundColor(Colors.subtitle)
                .padding(.top, 6)

            PetPicker()
                .padding(.top, 16)
        }
        .padding(.top, 32)
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(Fonts.bodyBold(12.5))
            .kerning(0.5)
            .textCase(.uppercase)
            .foregroundColor(Colors.cardMeta)
    }

    private func formatGoal(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }

    // MARK: - Actions

    private func commitGoal() {
        let trimmed = draft.trimmingCharacters(in: .whitespaces)
        let parsed = trimmed.isEmpty ? GOAL_DEFAULT : (Int(trimmed) ?? GOAL_DEFAULT)
        draft = String(settings.setGoal(parsed))
    }

    private func goBack() {
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
