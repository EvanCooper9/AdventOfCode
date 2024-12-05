import AOCKit
import Algorithms

final class Day04: Solution {
    override func question1() -> Any {
        let target = "XMAS"
        let targetReversed = String(target.reversed())

        var count = 0

        for r in rows {
            count += r.components(separatedBy: target).count - 1
            count += r.components(separatedBy: targetReversed).count - 1
        }

        for c in cols {
            count += c.components(separatedBy: target).count - 1
            count += c.components(separatedBy: targetReversed).count - 1
        }

        for d in diagonals {
            count += d.components(separatedBy: target).count - 1
            count += d.components(separatedBy: targetReversed).count - 1
        }

        return count
    }

    override func question2() -> Any {
        let input = input
        var count = 0
        let forward = "MAS".characters
        let backward = "SAM".characters
        for y in 1 ..< (input.count - 1) {
            for x in 1 ..< (input[y].count - 1) {
                if input[y][x] == "A" {
                    let dA = [input[y - 1][x - 1], "A", input[y + 1][x + 1]]
                    let dB = [input[y + 1][x - 1], "A", input[y - 1][x + 1]]

                    if (dA == forward || dA == backward) && (dB == forward || dB == backward) {
                        count += 1
                    }
                }
            }
        }
        return count
    }

    private var diagonals: [String] {
        var diagonals = [Diagonal]()

        struct Diagonal: Hashable {
            struct Point: Hashable {
                let x: Int
                let y: Int
            }

            let start: Point
            let value: String
        }

        let height = input.count
        let width = input[0].count
        for y in 0 ..< height {
            var leadingUp = [Character]()
            var leadingDown = [Character]()
            var trailingUp = [Character]()
            var trailingDown = [Character]()
            for x in 0 ..< width {
                if let c = input[safe: y - x]?[safe: x] {
                    leadingUp.append(c)
                }
                if let c = input[safe: y + x]?[safe: x] {
                    leadingDown.append(c)
                }
                if let c = input[safe: y - x]?[safe: width - x - 1] {
                    trailingUp.append(c)
                }
                if let c = input[safe: y + x]?[safe: width - x - 1] {
                    trailingDown.append(c)
                }
            }

            diagonals.append(contentsOf: [
                Diagonal(start: .init(x: leadingUp.count - 1, y: y - leadingUp.count + 1), value: leadingUp.string),
                Diagonal(start: .init(x: 0, y: y), value: leadingDown.string),
                Diagonal(start: .init(x: width - trailingUp.count, y: y - trailingUp.count + 1), value: trailingUp.reversed().string),
                Diagonal(start: .init(x: width - 1, y: y), value: trailingDown.reversed().string),
            ])
        }

        return diagonals
            .uniqued()
            .map(\.value)
    }
}

extension Array where Element == Character {
    var string: String {
        map(String.init).joined()
    }
}
