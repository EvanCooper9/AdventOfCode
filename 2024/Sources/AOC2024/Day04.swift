import AOCKit
import Algorithms

final class Day04: Solution {
    override func question1() -> Any {
        (rows + cols + diagonals)
            .map { line in
                ["XMAS", "SAMX"]
                    .map { line.components(separatedBy: $0).count - 1 }
                    .sum
            }
            .sum
    }

    override func question2() -> Any {
        let forward = "MAS".characters
        let backward = "SAM".characters
        return (1 ..< (input.count - 1)).map { y in
            (1 ..< (input[y].count - 1)).map { x in
                if input[y][x] == "A" {
                    let diagonalA = [input[y - 1][x - 1], "A", input[y + 1][x + 1]]
                    let diagonalB = [input[y + 1][x - 1], "A", input[y - 1][x + 1]]

                    if (diagonalA == forward || diagonalA == backward) && (diagonalB == forward || diagonalB == backward) {
                        return 1
                    }
                }
                return 0
            }
            .sum
        }
        .sum
    }

    private var diagonals: [String] {
        var diagonals = [Diagonal]()
        struct Diagonal: Hashable {
            let startX: Int
            let startY: Int
            let value: String
        }

        let width = input[0].count
        for y in 0 ..< input.count {
            var leadingUp = [Character]()
            var leadingDown = [Character]()
            var trailingUp = [Character]()
            var trailingDown = [Character]()
            for x in 0 ..< width {
                if let c = input[safe: y - x]?[safe: x] { leadingUp.append(c) }
                if let c = input[safe: y + x]?[safe: x] { leadingDown.append(c) }
                if let c = input[safe: y - x]?[safe: width - x - 1] { trailingUp.append(c) }
                if let c = input[safe: y + x]?[safe: width - x - 1] { trailingDown.append(c) }
            }

            diagonals.append(contentsOf: [
                Diagonal(startX: leadingUp.count - 1, startY: y - leadingUp.count + 1, value: leadingUp.string),
                Diagonal(startX: 0, startY: y, value: leadingDown.string),
                Diagonal(startX: width - trailingUp.count, startY: y - trailingUp.count + 1, value: trailingUp.reversed().string),
                Diagonal(startX: width - 1, startY: y, value: trailingDown.reversed().string),
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
