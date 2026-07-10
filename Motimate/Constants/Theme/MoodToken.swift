protocol MoodToken {
    associatedtype Value

    var day: [Mood: Value] { get }
    var night: Value { get }
}

extension MoodToken {
    func resolve(_ theme: Theme, _ mood: Mood) -> Value {
        theme == .night
            ? night
            : day[mood]!
    }
}
