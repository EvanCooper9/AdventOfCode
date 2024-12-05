public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] { Array(Set(self)) }
}

public extension Array {
    func filterNot(_ isIncluded: (Element) -> Bool) -> Self {
        filter { !isIncluded($0) }
    }
    
    var middle: Element? {
        guard count != 0 else { return nil }

        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}

public extension Collection where Element: Collection {
    func flattened() -> [Element.Element] { reduce([], +) }

    func contains(x: Int, y: Int) -> Bool {
        (0..<count).contains(y) && (0..<first!.count).contains(x)
    }

    subscript(x: Element.Index, y: Index) -> Self.Element.Element {
        self[y][x]
    }
}
