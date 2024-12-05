import AOCKit
import Algorithms

final class Day05: Solution {

    private struct Rule: Hashable {
        let first: Int
        let second: Int
    }

    private typealias Update = [Int]

    override func question1() -> Any {
        let (rules, updates) = buildInput()
        return updates
            .filter { valid($0, rules: rules) }
            .compactMap(\.middle)
            .sum
    }

    override func question2() -> Any {
        let (rules, updates) = buildInput()
        return updates
            .filter { !valid($0, rules: rules) }
            .map { update in
                var fixed = update
                while !valid(fixed, rules: rules) {
                    fixed.sort { lhs, rhs in
                        rules.contains(Rule(first: lhs, second: rhs))
                    }
                }
                return fixed
            }
            .compactMap(\.middle)
            .sum
    }

    private func valid(_ update: Update, rules: Set<Rule>) -> Bool {
        update.adjacentPairs().allSatisfy { lhs, rhs in
            let brokenRule = Rule(first: rhs, second: lhs)
            return !rules.contains(brokenRule)
        }
    }

    private func buildInput() -> (rules: Set<Rule>, updates: [Update]) {
        var rules = Set<Rule>()
        var updates = [Update]()
        var buildRules = true
        for row in input {
            if row.isEmpty {
                buildRules = false
            } else if buildRules {
                let numbers = row.split(separator: "|")
                    .map(String.init)
                    .compactMap(Int.init)
                rules.insert(Rule(first: numbers[0], second: numbers[1]))
            } else {
                let update = row.split(separator: ",")
                    .map(String.init)
                    .compactMap(Int.init)
                updates.append(update)
            }
        }

        return (rules, updates)
    }
}
