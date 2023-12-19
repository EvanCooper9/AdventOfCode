import Algorithms
import AOCKit

final class Day14: Solution {

    func question1() -> Any {
        let rolled = roll(input: input.filter({ !$0.isEmpty }), direction: .north)
        return load(of: rolled)
    }

    func question2() -> Any {
        // thanks reddit, this repeats
        let totalCycles = 1_000_000_000
        var current = input.filter({ !$0.isEmpty })
        var cache = [String: Int]()
        for cycle in 0..<totalCycles {
            let key = current.joined()
            if let cached = cache[key] {
                let cycleLength = cycle - cached
                let remainingCycles = (totalCycles - cycle) % cycleLength
                for _ in 0..<remainingCycles {
                    spin(input: &current)
                }
                return load(of: current)
            } else {
                cache[current.joined()] = cycle
                spin(input: &current)
            }
        }

        return 0
    }

    private func load(of input: [String]) -> Int {
        input
            .reversed()
            .enumerated()
            .map { index, row in
                row.filter { $0 == "O" }.count * (index + 1)
            }
            .sum
    }

    private func spin(input: inout [String]) {
        [Direction.north, .west, .south, .east].forEach { direction in
            input = roll(input: input, direction: direction)
        }
    }

    private func roll(input: [String], direction: Direction) -> [String] {
        let input = direction.transpose ? input.transposed : input

        func rolledLine(rockCount: Int, emptyCount: Int) -> String {
            let components = [
                String(repeating: "O", count: rockCount),
                String(repeating: ".", count: emptyCount)
            ]
            return direction.leading ? components.joined() : components.reversed().joined()
        }

        let rolledInput = input
            .map { line in
                var newLine = ""
                var currentRoundedRockCount = 0
                var currentEmptyCount = 0
                for character in line.characters {
                    switch character {
                    case "O": currentRoundedRockCount += 1
                    case ".": currentEmptyCount += 1
                    case "#":
                        newLine += rolledLine(rockCount: currentRoundedRockCount, emptyCount: currentEmptyCount) + "#"
                        currentRoundedRockCount = 0
                        currentEmptyCount = 0
                    default:
                        continue
                    }
                }
                newLine += rolledLine(rockCount: currentRoundedRockCount, emptyCount: currentEmptyCount)
                return newLine
            }

        return direction.transpose ? rolledInput.transposed : rolledInput
    }

    private enum Direction {
        case north, east, south, west

        var transpose: Bool {
            switch self {
            case .north, .south: return true
            case .east, .west: return false
            }
        }

        var leading: Bool {
            switch self {
            case .north, .west: return true
            case .south, .east: return false
            }
        }
    }
}
