import Combine
import Foundation

/// Port of `src/steps/useDailySteps.ts` — the app's single source of movement truth.
///
/// Requests permission, fetches today's step count, then subscribes to live
/// updates. Derives `mood`/`progress` via `StepsConvertor` so consumers get
/// everything they need from one object. Failure modes (denied permission, no
/// pedometer) are surfaced as state, never thrown — the UI degrades gracefully.
///
/// The current hour is refreshed on a ~60s timer so a REAL-mode energetic pet
/// can turn SAD past noon while the screen stays open.
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

    private var hour: Int
    private var hourTimer: Timer?
    private var unsubscribe: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    private var started = false

    init(settings: SettingsStore, reader: StepReading = StepReader(), hour: Int? = nil) {
        self.settings = settings
        self.reader = reader
        self.hour = hour ?? Calendar.current.component(.hour, from: Date())

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

        startHourTimer()

        Task { [weak self] in
            guard let self else { return }

            let state = await self.reader.requestPermission()
            self.permission = state

            guard state == .granted else {
                self.loading = false
                return
            }

            let initial = await self.reader.getTodaySteps()
            self.steps = initial
            self.loading = false
            self.recompute()

            self.unsubscribe = self.reader.subscribe { [weak self] next in
                guard let self else { return }
                Task { @MainActor in
                    self.steps = next
                    self.recompute()
                }
            }
        }
    }

    private func startHourTimer() {
        hourTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                let now = Calendar.current.component(.hour, from: Date())
                guard now != self.hour else { return }
                self.hour = now
                self.recompute()
            }
        }
    }

    private func recompute(goal: Int? = nil, mode: GameMode? = nil) {
        let goal = goal ?? settings.goal
        let mode = mode ?? settings.gameMode
        mood = StepsConvertor.toMood(steps: steps, goal: goal, mode: mode, hour: hour)
        progress = StepsConvertor.toProgress(steps: steps, goal: goal)
    }

    func stop() {
        hourTimer?.invalidate()
        hourTimer = nil
        unsubscribe?()
        unsubscribe = nil
    }

    deinit {
        hourTimer?.invalidate()
        unsubscribe?()
    }
}
