import Combine
import Foundation

/// Port of `src/steps/useDailySteps.ts` — the app's single source of movement truth.
///
/// Requests permission, fetches today's step count, then subscribes to live
/// updates. Derives `mood`/`progress` via `StepsConvertor` so consumers get
/// everything they need from one object. Failure modes (denied permission, no
/// pedometer) are surfaced as state, never thrown — the UI degrades gracefully.
///
/// The current hour comes from an injected `HourClock`; subscribing to its
/// change stream lets a REAL-mode energetic pet turn SAD past noon while the
/// screen stays open, without this model owning a `Timer` or touching `Calendar`.
@MainActor
final class DailyStepsModel: ObservableObject {
    @Published private(set) var steps: Int = 0
    @Published private(set) var mood: Mood = .energetic
    @Published private(set) var progress: Double = 0 // 0..1

    @Published private(set) var permission: PermissionState? = nil
    @Published private(set) var loading: Bool = true
    @Published private(set) var error: String? = nil

    private let settings: SettingsStore
    private let reader: StepReading
    private let clock: HourClock

    private var unsubscribe: (() -> Void)?
    private var unsubscribeHour: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    private var started = false

    init(settings: SettingsStore, reader: StepReading = StepReader(), clock: HourClock = SystemHourClock()) {
        self.settings = settings
        self.reader = reader
        self.clock = clock

        // Goal/mode live in SettingsStore; recompute when either changes so the
        // fan-out stays self-contained.
        // `@Published` fires in `willSet`, so `settings.goal` is still stale when
        // the sink runs — recompute from the freshly-emitted value, not the store.
        settings.$goal
            .sink { [weak self] goal in self?.recompute(goal: goal) }
            .store(in: &cancellables)
        settings.$gameMode
            .sink { [weak self] mode in self?.recompute(mode: mode) }
            .store(in: &cancellables)

        recompute()
    }

    /// Permission → fetch → subscribe lifecycle. Idempotent; safe to call once
    /// when the view appears.
    func start() {
        guard !started else { return }
        started = true

        unsubscribeHour = clock.subscribe { [weak self] _ in self?.recompute() }

        Task { [weak self] in
            guard let self else { return }

            let state = await self.reader.requestPermission()
            self.permission = state

            guard state == .granted else {
                self.loading = false
                return
            }

            self.loading = false
            await self.loadAndSubscribe()
        }
    }

    func refresh() {
        guard started else { return }

        clock.refresh()
        recompute()

        guard permission == .granted else { return }

        Task { [weak self] in
            guard let self else { return }
            await self.loadAndSubscribe()
        }
    }

    private func loadAndSubscribe() async {
        let freshSteps = await reader.getTodaySteps()
        steps = freshSteps
        recompute()

        unsubscribe?()
        unsubscribe = reader.subscribe { [weak self] next in
            guard let self else { return }
            Task { @MainActor in
                self.steps = next
                self.recompute()
            }
        }
    }

    private func recompute(goal: Int? = nil, mode: GameMode? = nil) {
        let goal = goal ?? settings.goal
        let mode = mode ?? settings.gameMode

        mood = StepsConvertor.toMood(
            steps: steps,
            goal: goal,
            mode: mode,
            hour: clock.hour
        )
        progress = StepsConvertor.toProgress(
            steps: steps,
            goal: goal
        )
    }

    func stop() {
        unsubscribeHour?()
        unsubscribeHour = nil
        unsubscribe?()
        unsubscribe = nil
    }

    deinit {
        unsubscribeHour?()
        unsubscribe?()
    }
}
