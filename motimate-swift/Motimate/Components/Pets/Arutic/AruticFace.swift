import SwiftUI

struct AruticFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat
    let scale: CGFloat

    private static let LID = "#4A3526"
    private static let FACE_WIDTH: CGFloat = 124
    private static let EYE_WIDTH: CGFloat = 22
    private static let EYE_INSET: CGFloat = 31

    private var leftEyeDx: CGFloat { Self.EYE_INSET }
    private var rightEyeDx: CGFloat { Self.FACE_WIDTH - Self.EYE_INSET - Self.EYE_WIDTH }

    var body: some View {
        ZStack {
            nose
            face
        }
    }

    // MARK: - Shared

    private var nose: some View {
        let d = "M \(ox + (62 - 6) * scale) \(oy + 80 * scale) "
            + "h \(12 * scale) "
            + "v \((14 - 6) * scale) "
            + "q 0 \(6 * scale) \(-6 * scale) \(6 * scale) "
            + "q \(-6 * scale) 0 \(-6 * scale) \(-6 * scale) Z"
        return svgPath(d).fill(Color(hex: "#AA6E41").opacity(0.32))
    }

    // MARK: - Per-mood

    @ViewBuilder
    private var face: some View {
        switch mood {
        case .energetic:
            ZStack {
                AruticBrows(
                    ox: ox,
                    oy: oy,
                    scale: scale,
                    kind: .neutral
                )
                eyes(lidTop: -7)
                smile
            }
        case .calm:
            ZStack {
                AruticBrows(
                    ox: ox,
                    oy: oy,
                    scale: scale,
                    kind: .neutral
                )
                eyes(lidTop: -5)
            }
        case .tired:
            ZStack {
                AruticBrows(
                    ox: ox,
                    oy: oy,
                    scale: scale,
                    kind: .neutral
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 33 * scale,
                    dy: 70 * scale,
                    d: "q \(10 * scale) \(7 * scale) \(20 * scale) 0",
                    color: Color(hex: Self.LID)
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (124 - 33 - 20) * scale,
                    dy: 70 * scale,
                    d: "q \(10 * scale) \(7 * scale) \(20 * scale) 0",
                    color: Color(hex: Self.LID)
                )
            }
        case .sad:
            ZStack {
                AruticBrows(
                    ox: ox,
                    oy: oy,
                    scale: scale,
                    kind: .angry
                )
                eyes(lidTop: -4)
            }
        }
    }

    private func eyes(lidTop: CGFloat) -> some View {
        ZStack {
            AruticEye(
                ox: ox,
                oy: oy,
                dx: leftEyeDx,
                dy: 66,
                scale: scale,
                irisDx: 5,
                lidTop: lidTop
            )
            AruticEye(
                ox: ox,
                oy: oy,
                dx: rightEyeDx,
                dy: 66,
                scale: scale,
                irisDx: 6,
                lidTop: lidTop
            )
        }
    }

    private var smile: some View {
        let d = "M \(ox + (62 - 10) * scale) \(oy + 99 * scale) "
            + "h \(20 * scale) "
            + "v \(1 * scale) "
            + "q 0 \(6 * scale) \(-10 * scale) \(6 * scale) "
            + "q \(-10 * scale) 0 \(-10 * scale) \(-6 * scale) Z"
        return svgPath(d).fill(Color(hex: "#E9CFA8"))
    }
}

struct AruticBrows: View {
    enum Kind { case neutral, angry }

    let ox: CGFloat
    let oy: CGFloat
    let scale: CGFloat
    let kind: Kind

    private static let BROW = "#9A7038"
    private static let FACE_WIDTH: CGFloat = 124
    private static let BROW_Y: CGFloat = 58
    private static let BROW_HEIGHT: CGFloat = 6

    private var params: (inset: CGFloat, width: CGFloat, angle: Double) {
        switch kind {
        case .neutral: return (28, 24, 7)
        case .angry: return (30, 26, 20)
        }
    }

    var body: some View {
        let p = params
        let rightX = Self.FACE_WIDTH - p.inset - p.width
        let y = oy + Self.BROW_Y * scale
        let pivotY = oy + (Self.BROW_Y + Self.BROW_HEIGHT / 2) * scale
        let w = p.width * scale
        let h = Self.BROW_HEIGHT * scale
        let radius = (Self.BROW_HEIGHT / 2) * scale

        ZStack {
            brow(
                x: ox + p.inset * scale,
                y: y,
                w: w,
                h: h,
                radius: radius,
                angle: p.angle,
                pivot: CGPoint(x: ox + (p.inset + p.width / 2) * scale, y: pivotY)
            )
            brow(
                x: ox + rightX * scale,
                y: y,
                w: w,
                h: h,
                radius: radius,
                angle: -p.angle,
                pivot: CGPoint(x: ox + (rightX + p.width / 2) * scale, y: pivotY)
            )
        }
    }

    private func brow(
        x: CGFloat,
        y: CGFloat,
        w: CGFloat,
        h: CGFloat,
        radius: CGFloat,
        angle: Double,
        pivot: CGPoint
    ) -> some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(Color(hex: Self.BROW))
            .frame(width: w, height: h)
            .position(x: x + w / 2, y: y + h / 2)
            .rotationEffect(.degrees(angle), anchor: UnitPoint(x: pivot.x / PET_SIZE, y: pivot.y / PET_SIZE))
    }
}
