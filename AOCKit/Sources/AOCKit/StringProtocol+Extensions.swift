public extension StringProtocol {
    subscript(offset: Int) -> Character {
        get { self[index(startIndex, offsetBy: offset)] }
//        set {
//            var characters = self.characters
//            characters[offset] = newValue
//            self = String(characters)
//        }
    }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
    subscript(safe offset: Int) -> Character? {
        guard offset >= 0 && offset < count else { return nil }
        return self[offset]
    }
}

public extension StringProtocol {
    var characters: [Character] {
        var characters = [Character]()
        forEach { characters.append($0) }
        return characters
    }

    var int: Int? {
        Int(self)
    }

    func toInt() -> Int? {
        Int(self)
    }
}

public extension String {
    subscript(offset: Int) -> Character {
        get { self[index(startIndex, offsetBy: offset)] }
        set {
            var characters = self.characters
            characters[offset] = newValue
            self = String(characters)
        }
    }
}
