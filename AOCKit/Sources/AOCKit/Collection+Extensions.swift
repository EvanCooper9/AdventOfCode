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

    var product: Int {
        reduce(1, *)
    }
}

public extension Collection where Element: Collection {
    func flattened() -> [Element.Element] { reduce([], +) }

    func contains(x: Int, y: Int) -> Bool {
        (0..<count).contains(y) && (0..<first!.count).contains(x)
    }

    func contains(point: Point) -> Bool {
        contains(x: point.x, y: point.y)
    }

    subscript(x: Element.Index, y: Index) -> Self.Element.Element {
        self[y][x]
    }
}
