import Foundation

struct MessageSet {
    let headline: String
    let subtitle: String
    let meta: String
    let footer: String
}

private func randomFrom<T>(_ items: [T]) -> T {
    items.randomElement()!
}

func pickMessages(_ pools: [Mood: [MessageSet]]) -> [Mood: MessageSet] {
    Dictionary(uniqueKeysWithValues: Mood.allCases.map { ($0, randomFrom(pools[$0]!)) })
}
