import Algorithms
import AOCKit

final class Day08: Solution {

    func question1() -> Any {
        steps(from: "AAA", isAtDestination: { $0 == "ZZZ" })
    }
    
    func question2() -> Any {
        let minSteps = map.keys
            .filter { $0.hasSuffix("A") }
            .map { steps(from: $0, isAtDestination: { $0.hasSuffix("Z") }) }

        return lcm(minSteps)
    }

    init() {
        instructions = input.first!.compactMap(Direction.init)
        let nodes = input
            .dropFirst(2)
            .map { line in
                let key = line.split(separator: "=").first!.trimmingCharacters(in: .whitespaces)
                let node = Node(line.split(separator: "=").last!)
                return (key, node)
            }

        map = Dictionary(uniqueKeysWithValues: nodes)
    }

    private func steps(from node: String, isAtDestination: (String) -> Bool) -> Int {
        var currentNode = node
        var currentStepCount = 0
        while !isAtDestination(currentNode) {
            let instruction = instructions[currentStepCount % instructions.count]
            switch instruction {
            case .left:
                currentNode = map[currentNode]!.left
            case .right:
                currentNode = map[currentNode]!.right
            }
            currentStepCount += 1
        }

        return currentStepCount
    }

    private enum Direction: Character {
        case left = "L", right = "R"
    }

    private struct Node {
        let left: String
        let right: String

        init(_ line: Substring) {
            left = String(line.split(separator: ",").first!.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst())
            right = String(line.split(separator: ",").last!.trimmingCharacters(in: .whitespacesAndNewlines).dropLast())
        }
    }

    private var instructions = [Direction]()
    private var map = [String: Node]()
}
