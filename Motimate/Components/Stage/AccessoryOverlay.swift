import SwiftUI

struct AccessoryOverlay: View {
    let accessory: AccessoryId
    let petId: PetId
    let mood: Mood
    let petSize: CGFloat

    private static let BASE: CGFloat = PET_SIZE

    var body: some View {
        let anchor = accessoryAnchor(accessory, petId)
        let art = Accessory.define(accessory).art(mood, Self.BASE, anchor.spread)

        art
            .scaleEffect(anchor.scale, anchor: .center)
            .rotationEffect(.degrees(anchor.rotationDegrees), anchor: .center)
            .position(x: anchor.position.x, y: anchor.position.y)
            .frame(width: Self.BASE, height: Self.BASE)
            .scaleEffect(petSize / Self.BASE)
    }
}
