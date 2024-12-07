public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] { Array(Set(self)) }
}

public extension Array {
    func filterNot(_ isIncluded: (Element) -> Bool) -> Self {
        filter { !isIncluded($0) }
    }

    var second: Element? {
        guard count >= 2 else { return nil }
        return self[1]
    }

    var middle: Element? {
        guard count != 0 else { return nil }

        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}
