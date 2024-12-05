import AOCKit
import Algorithms

final class Day03: Solution {
    override func question1() -> Any {
        let input = input.joined()
        let regex = #/mul\(\d+\,\d+\)/#
        return input.matches(of: regex)
            .map { match in
                input[match.range].product
            }
            .sum
    }

    override func question2() -> Any {
        let input = input.joined()
        let regex = #/mul\(\d+\,\d+\)|do\(\)|don\'t\(\)/#
        var ignore = false
        return input.matches(of: regex)
            .map { match in
                let string = input[match.range]
                if string == "do()" {
                    ignore = false
                } else if string == "don't()" {
                    ignore = true
                } else if !ignore {
                    return string.product
                }
                return 0
            }
            .sum
    }
}

private extension Substring {
    var product: Int {
        self.dropFirst(4) // drop "mul("
            .dropLast(1) // drop ")"
            .split(separator: ",")
            .compactMap { $0.toInt() }
            .product
    }
}
