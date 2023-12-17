import Algorithms
import AOCKit

final class Day12: Solution {

    func question1() -> Any {
        rows
            .map { combos(springs: $0.springs, remainingGroups: $0.contiguousDamages) }
            .reduce(0, +)
    }

    func question2() -> Any {
        let expandedRows = rows.map { row in
            let repeatedSprings = Array(repeating: row.springs, count: 5).joined(by: .unknown)
            let repeatedContiguousDamanges = Array(repeating: row.contiguousDamages, count: 5).joined()
            return Row(springs: Array(repeatedSprings), contiguousDamages: Array(repeatedContiguousDamanges))
        }

        return expandedRows
            .map { combos(springs: $0.springs, remainingGroups: $0.contiguousDamages) }
            .reduce(0, +)
    }

    init() {
        rows = input.map { line in
            let springs = line.split(separator: " ")
                .first!
                .compactMap(Spring.init)

            let contiguousDamages = line.split(separator: " ")
                .last!
                .split(separator: ",")
                .map(String.init)
                .compactMap(Int.init)
            return Row(springs: springs, contiguousDamages: contiguousDamages)
        }
    }
    
    private var cachedValues = [CacheKey: Int]()
    private struct CacheKey: Hashable {
        let springs: [Spring]
        let groups: [Int]
    }

    private func combos(springs: [Spring], remainingGroups: [Int]) -> Int {
        let cacheKey = CacheKey(springs: springs, groups: remainingGroups)
        if let cachedValue = cachedValues[cacheKey] {
            return cachedValue
        }

        let value: Int
        if springs.isEmpty {
            // no more springs to check, need to make sure no more groups required
            value = remainingGroups.isEmpty ? 1 : 0
        } else if remainingGroups.isEmpty {
            // no more groups, need to make sure no more damanged springs
            value = springs.contains(.damaged) ? 0 : 1
        } else {
            let remaingingSprings = springs[1...]
            let first = springs[0]

            switch first {
            case .operational:
                value = combos(springs: Array(remaingingSprings), remainingGroups: remainingGroups)
            case .damaged:
                let group = remainingGroups[0]
                if springs.count >= group && // long enough
                   !Set(springs[..<group]).contains(.operational) && // make of only things that can be damaged
                   (springs.count == group || springs[group] != .damaged) {
                    let remainingSprings = springs.count > group ? Array(springs[(group + 1)...]) : []
                    let remainingGroups = Array(remainingGroups[1...])
                    value = combos(springs: remainingSprings, remainingGroups: remainingGroups)
                } else {
                    value = 0
                }
            case .unknown:
                let damaged = [.damaged] + remaingingSprings
                let operational = [.operational] + remaingingSprings
                value = combos(springs: damaged, remainingGroups: remainingGroups) + combos(springs: operational, remainingGroups: remainingGroups)
            }
        }

        cachedValues[cacheKey] = value
        return value
    }

    private enum Spring: Character {
        case operational = "."
        case damaged = "#"
        case unknown = "?"
    }

    private struct Row {
        let springs: [Spring]
        let contiguousDamages: [Int]
    }

    private var rows = [Row]()
}
