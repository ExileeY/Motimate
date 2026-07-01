import SwiftUI

struct AruticEye: View {
    let ox: CGFloat
    let oy: CGFloat
    let dx: CGFloat
    let dy: CGFloat
    let scale: CGFloat
    let irisDx: CGFloat
    let lidTop: CGFloat

    private static let EYE = (w: CGFloat(22), h: CGFloat(13))
    private static let IRIS_RADIUS: CGFloat = 5.5
    private static let PUPIL_RADIUS: CGFloat = 2.5
    private static let LID = (w: CGFloat(22), h: CGFloat(8), radius: CGFloat(12))
    private static let IRIS_MARGIN_Y: CGFloat = 2
    private static let PUPIL_INSET: CGFloat = 3

    var body: some View {
        let x = ox + dx * scale
        let y = oy + dy * scale

        let scleraRx = (Self.EYE.w / 2) * scale
        let scleraRy = (Self.EYE.h / 2) * scale
        let scleraCx = x + scleraRx
        let scleraCy = y + scleraRy

        let irisCx = x + (irisDx + Self.IRIS_RADIUS) * scale
        let irisCy = y + (Self.IRIS_MARGIN_Y + Self.IRIS_RADIUS) * scale
        let irisR = Self.IRIS_RADIUS * scale

        let pupilCx = x + (irisDx + Self.PUPIL_INSET + Self.PUPIL_RADIUS) * scale
        let pupilCy = y + (Self.IRIS_MARGIN_Y + Self.PUPIL_INSET + Self.PUPIL_RADIUS) * scale
        let pupilR = Self.PUPIL_RADIUS * scale

        let lid = Self.LID
        let lidD = """
        M \(x) \(y + lidTop * scale) \
        h \(lid.w * scale) \
        v \((lid.h - lid.radius) * scale) \
        q 0 \(lid.radius * scale) \(-lid.radius * scale) \(lid.radius * scale) \
        h \(-(lid.w - 2 * lid.radius) * scale) \
        q \(-lid.radius * scale) 0 \(-lid.radius * scale) \(-lid.radius * scale) \
        Z
        """

        ZStack {
            // Sclera
            Ellipse()
                .fill(Color(hex: "#F4ECDF"))
                .frame(width: scleraRx * 2, height: scleraRy * 2)
                .position(x: scleraCx, y: scleraCy)

            // Iris + pupil + eyelid
            ZStack {
                Circle()
                    .fill(radialGradient([
                        GStop("#B9CDD6", 0),
                        GStop("#8AA7B2", 1),
                    ], cx: 0.4, cy: 0.35, r: 0.7, side: irisR * 2))
                    .frame(width: irisR * 2, height: irisR * 2)
                    .position(x: irisCx, y: irisCy)

                Circle()
                    .fill(Color(hex: "#2E2A28"))
                    .frame(width: pupilR * 2, height: pupilR * 2)
                    .position(x: pupilCx, y: pupilCy)

                svgPath(lidD)
                    .fill(Color(hex: "#E0A878"))
            }
            .frame(width: PET_SIZE, height: PET_SIZE)
            .mask(
                Ellipse()
                    .frame(width: scleraRx * 2, height: scleraRy * 2)
                    .position(x: scleraCx, y: scleraCy)
                    .frame(width: PET_SIZE, height: PET_SIZE)
            )
        }
    }
}
