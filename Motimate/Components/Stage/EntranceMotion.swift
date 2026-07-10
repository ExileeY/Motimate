import SwiftUI

struct EntranceMotionParams {
    var active: Bool = false
    var onFinished: () -> Void = {}
}

struct EntranceMotion<Content: View>: View {
    let params: EntranceMotionParams
    let content: Content

    init(params: EntranceMotionParams, @ViewBuilder content: () -> Content) {
        self.params = params
        self.content = content()
    }

    var body: some View {
        if params.active {
            OnceLoop(
                durationMs: EntranceCurve.durationMs,
                onFinished: params.onFinished
            ) { progress in
                let frame = EntranceCurve.frame(at: CGFloat(progress))
                content
                    .scaleEffect(frame.scale)
                    .offset(y: frame.offsetY)
                    .opacity(Double(frame.opacity))
            }
            .id(params.active) // start the clock when the entrance flag flips true
        } else {
            content
        }
    }
}
