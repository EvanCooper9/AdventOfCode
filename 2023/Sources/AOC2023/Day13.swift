import Algorithms
import AOCKit

final class Day13: Solution {

    func question1() -> Any {
        patterns
            .map { pattern in
                if let verticalMirrorIndex = indexOfMirror(in: pattern) {
                    return verticalMirrorIndex
                } else if let horizontalMirrorIndex = indexOfMirror(in: pattern.transposed) {
                    return horizontalMirrorIndex * 100
                }
                return 0
            }
            .sum
    }

    func question2() -> Any {
        patterns
            .enumerated()
            .map { index, smudgedPattern in
                let smudgedVerticalMirrorIndex = indexOfMirror(in: smudgedPattern)
                let smudgedHorizontalMirrorIndex = indexOfMirror(in: smudgedPattern.transposed)

                for y in 0..<smudgedPattern.count {
                    for x in 0..<smudgedPattern[y].count {
                        var fixedPattern = smudgedPattern
                        fixedPattern[y][x] = fixedPattern[y][x] == "." ? "#": "."

                        if let verticalMirrorIndex = indexOfMirror(in: fixedPattern), verticalMirrorIndex != smudgedVerticalMirrorIndex {
                            return verticalMirrorIndex
                        } else if let horizontalMirrorIndex = indexOfMirror(in: fixedPattern.transposed), horizontalMirrorIndex != smudgedHorizontalMirrorIndex {
                            return horizontalMirrorIndex * 100
                        }
                    }
                }

                return 0
            }
            .sum
    }

    private func indexOfMirror(in pattern: Pattern) -> Int? {
        let verticalMirrorRange = 1..<pattern[0].count
        return verticalMirrorRange.first { verticalMirrorIndex in
            return pattern.allSatisfy { row in
                let left = row[..<verticalMirrorIndex]
                let right = row[verticalMirrorIndex...]

                for i in 0..<min(left.count, right.count) {
                    if left[left.count - i - 1] != right[i] {
                        return false
                    }
                }
                return true
            }
        }
    }

    init() {
        patterns = input
            .split(separator: "")
            .map(Array.init)
    }

    private typealias Pattern = [String]
    private var patterns = [Pattern]()
}

extension Array where Element == String {
    var transposed: [String] {
        var transposed = Array(repeating: "", count: self[0].count)
        for y in indices {
            for (x, character) in self[y].enumerated() {
                transposed[x] += String(character)
            }
        }
        return transposed
    }
}
