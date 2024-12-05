import AOCKit

final class Day01: Solution {

    override func question1() -> Any {
        var (left, right) = lists()
        left.sort()
        right.sort()
        return left.indices
            .map { abs(left[$0] - right[$0]) }
            .sum
    }

    override func question2() -> Any {
        let (left, right) = lists()
        return left.reduce(0) { partialResult, number in
            partialResult + (number * right.count(where: { $0 == number }))
        }
    }

    private func lists() -> (left: [Int], right: [Int]) {
        var left = [Int]()
        var right = [Int]()
        input
            .compactMap { line -> (Int, Int)? in
                let split = line.split(separator: " ")
                guard let lhs = Int(split[0]), let rhs = Int(split[1]) else { return nil }
                return (lhs, rhs)
            }
            .forEach { lhs, rhs in
                left.append(lhs)
                right.append(rhs)
            }

        return (left, right)
    }
}
