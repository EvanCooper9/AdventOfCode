public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] { Array(Set(self)) }
}

public extension Collection where Element: Collection {
    func flattened() -> [Element.Element] { reduce([], +) }
}
