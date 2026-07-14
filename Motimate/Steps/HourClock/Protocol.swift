import Foundation

protocol HourClock {
    var hour: Int { get }
    func subscribe(onHour: @escaping (Int) -> Void) -> () -> Void
    func refresh()
}
