public extension Collection {
    subscript(safe index: Index) -> Element? where Index == Int {
        guard (0..<count).contains(index) else { return nil }
        return self[index]
    }
}
