import AOCKit
import Algorithms

final class Day07: Solution {
    
    override func question1() -> Any {
        solve(operations: [.multiply, .add])
    }
    
    override func question2() -> Any {
        solve(operations: [.multiply, .add, .concatenate])
    }

    private enum Operation: CaseIterable {
        case multiply
        case add
        case concatenate

        func perform(lhs: Int?, rhs: Int) -> Int {
            guard let lhs else { return rhs }
            switch self {
            case .multiply: return lhs * rhs
            case .add: return lhs + rhs
            case .concatenate: return lhs * pow(10, log10(rhs) + 1) + rhs
            }
        }
    }

    private func solve(operations: [Operation]) -> Int {
        input.reduce(0) { previous, line in
            let split = line.split(separator: ":")
            let target = Int(split[0])!
            let numbers = split[1].split(separator: " ").compactMap { $0.toInt() }
            let search = search(numbers: numbers, operations: operations, target: target)
            return search ? previous + target : previous
        }
    }

    private func search(
        numbers: [Int],
        currentIndex: Int = 0,
        previousValue: Int? = nil,
        operation: Operation? = nil,
        operations: [Operation],
        target: Int
    ) -> Bool {
        guard let number = numbers[safe: currentIndex] else {
            return previousValue == target
        }
        let value = operation?.perform(lhs: previousValue, rhs: number) ?? number
        guard value <= target else { return false }
        return operations.contains { operation in
            search(
                numbers: numbers,
                currentIndex: currentIndex + 1,
                previousValue: value,
                operation: operation,
                operations: operations,
                target: target
            )
        }
    }
}
