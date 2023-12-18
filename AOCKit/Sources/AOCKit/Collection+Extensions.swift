public extension Collection {
    subscript(safe index: Index) -> Element? where Index == Int {
        guard (0..<count).contains(index) else { return nil }
        return self[index]
    }
}

public extension Collection where Element == Int {
    var sum: Int {
        reduce(0, +)
    }
}
