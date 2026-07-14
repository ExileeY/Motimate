import SwiftUI

struct HapticSwitchToggleStyle: ToggleStyle {
    let enabled: Bool
    let tint: Color

    private let trackWidth: CGFloat = 51
    private let trackHeight: CGFloat = 31
    private let knobInset: CGFloat = 2

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer(minLength: 12)
            track(isOn: configuration.isOn)
                .onTapGesture {
                    HapticsService.impact(.light, enabled: enabled)
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configuration.isOn.toggle()
                    }
                }
                .accessibilityAddTraits(configuration.isOn ? [.isSelected] : [])
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(configuration.isOn ? Text("On") : Text("Off"))
        .accessibilityAddTraits(.isButton)
    }

    private func track(isOn: Bool) -> some View {
        let knobDiameter = trackHeight - knobInset * 2
        return ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .fill(isOn ? tint : Color(.systemGray4))
            Circle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 1, y: 1)
                .frame(width: knobDiameter, height: knobDiameter)
                .padding(knobInset)
        }
        .frame(width: trackWidth, height: trackHeight)
    }
}

extension Toggle where Label == Text {
    func hapticSwitch(enabled: Bool, tint: Color) -> some View {
        toggleStyle(HapticSwitchToggleStyle(enabled: enabled, tint: tint))
    }
}
