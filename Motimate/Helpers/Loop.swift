import SwiftUI

enum LoopMode: Equatable {
    case pingPong
    case rise
    case once
}

enum LoopTiming {
    static func progress(
        elapsedMs: Double,
        durationMs: Double,
        delayMs: Double = 0,
        mode: LoopMode,
        active: Bool = true
    ) -> Double {
        guard active, durationMs > 0 else { return 0 }

        let delayedElapsed = elapsedMs - max(delayMs, 0)
        guard delayedElapsed >= 0 else { return 0 }

        switch mode {
        case .once:
            // A single ramp that holds at the end — must not wrap.
            return MathUtils.easeInOut(min(delayedElapsed / durationMs, 1))
        case .pingPong:
            let cycleElapsed = cycleOffset(elapsedMs: delayedElapsed, durationMs: durationMs)
            let halfDuration = durationMs / 2
            let rawProgress = cycleElapsed <= halfDuration
                ? cycleElapsed / halfDuration
                : 1 - ((cycleElapsed - halfDuration) / halfDuration)

            return MathUtils.easeInOut(rawProgress)
        case .rise:
            let cycleElapsed = cycleOffset(elapsedMs: delayedElapsed, durationMs: durationMs)
            return MathUtils.easeInOut(cycleElapsed / durationMs)
        }
    }

    private static func cycleOffset(elapsedMs: Double, durationMs: Double) -> Double {
        elapsedMs.truncatingRemainder(dividingBy: durationMs)
    }
}

struct LoopClock<Content: View>: View {
    let durationMs: Double
    let delayMs: Double
    let mode: LoopMode
    let active: Bool
    let content: (Double) -> Content
    let onFinished: () -> Void

    @State private var startDate = Date()
    @State private var finished = false

    init(
        durationMs: Double,
        delayMs: Double = 0,
        mode: LoopMode,
        active: Bool = true,
        @ViewBuilder content: @escaping (Double) -> Content,
        onFinished: @escaping () -> Void = {}
    ) {
        self.durationMs = durationMs
        self.delayMs = delayMs
        self.mode = mode
        self.active = active
        self.content = content
        self.onFinished = onFinished
    }

    var body: some View {
        if active {
            TimelineView(.animation) { timeline in
                let value = progress(at: timeline.date)
                content(value)
                    .onChange(of: value) { value in onceFinished(value) }
            }
            .onAppear(perform: reset)
            .onChange(of: durationMs) { _ in reset() }
            .onChange(of: delayMs) { _ in reset() }
            .onChange(of: mode) { _ in reset() }
        } else {
            content(0)
        }
    }

    private func progress(at date: Date) -> Double {
        LoopTiming.progress(
            elapsedMs: date.timeIntervalSince(startDate) * 1_000,
            durationMs: durationMs,
            delayMs: delayMs,
            mode: mode,
            active: active
        )
    }

    private func reset() {
        startDate = Date()
        finished = false
    }

    private func onceFinished(_ value: Double) {
        guard mode == .once, value >= 1, !finished else { return }

        finished = true
        onFinished()
    }
}

struct PingPongLoop<Content: View>: View {
    let durationMs: Double
    let delayMs: Double
    let active: Bool
    let content: (Double) -> Content

    init(
        durationMs: Double,
        delayMs: Double = 0,
        active: Bool = true,
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.durationMs = durationMs
        self.delayMs = delayMs
        self.active = active
        self.content = content
    }

    var body: some View {
        LoopClock(
            durationMs: durationMs,
            delayMs: delayMs,
            mode: .pingPong,
            active: active,
            content: content
        )
    }
}

struct RiseLoop<Content: View>: View {
    let durationMs: Double
    let delayMs: Double
    let active: Bool
    let content: (Double) -> Content

    init(
        durationMs: Double,
        delayMs: Double = 0,
        active: Bool = true,
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.durationMs = durationMs
        self.delayMs = delayMs
        self.active = active
        self.content = content
    }

    var body: some View {
        LoopClock(
            durationMs: durationMs,
            delayMs: delayMs,
            mode: .rise,
            active: active,
            content: content
        )
    }
}

struct OnceLoop<Content: View>: View {
    let durationMs: Double
    let delayMs: Double
    let content: (Double) -> Content
    let onFinished: () -> Void

    init(
        durationMs: Double,
        delayMs: Double = 0,
        onFinished: @escaping () -> Void = {},
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.durationMs = durationMs
        self.delayMs = delayMs
        self.onFinished = onFinished
        self.content = content
    }

    var body: some View {
        LoopClock(
            durationMs: durationMs,
            delayMs: delayMs,
            mode: .once,
            content: content,
            onFinished: onFinished
        )
    }
}

#if DEBUG
private struct LoopPreviewBar: View {
    let label: String
    let progress: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(label): \(progress, specifier: "%.2f")")
                .font(Fonts.bodyBold(13))
                .foregroundColor(Colors.text)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Colors.barTrack)
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 180 * progress)
            }
            .frame(width: 180, height: 8)
        }
    }
}

#Preview("Loop") {
    VStack(alignment: .leading, spacing: 18) {
        PingPongLoop(durationMs: 1_600) { progress in
            LoopPreviewBar(label: "Ping-pong", progress: progress, color: Colors.barFrom)
        }
        RiseLoop(durationMs: 1_600, delayMs: 450) { progress in
            LoopPreviewBar(label: "Rise", progress: progress, color: Colors.barTo)
        }
        PingPongLoop(durationMs: 1_600, active: false) { progress in
            LoopPreviewBar(label: "Inactive", progress: progress, color: Colors.cardMeta)
        }
    }
    .padding()
}
#endif
