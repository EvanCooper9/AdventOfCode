import Algorithms
import AOCKit

struct Day11: Solution {

    private struct Monkey {
        var inspectionCount = 0
        var items: [Int]
        var operation: (Int) -> Int
        var test: Int
        var targetMonkey: (Int) -> Int
    }
    
    private var monkeys: [Monkey] {
        lines(for: "day11", in: .module)
            .chunks(ofCount: 7)
            .map { chunk in
                let items = chunk[chunk.startIndex + 1].components(separatedBy: ": ").last!.components(separatedBy: ", ").compactMap(Int.init)
                let operation = chunk[chunk.startIndex + 2].components(separatedBy: "= ").last!.components(separatedBy: " ")
                let test = Int(chunk[chunk.startIndex + 3].split(separator: " ").last!)!
                let testSuccess = Int(chunk[chunk.startIndex + 4].split(separator: " ").last!)!
                let testFailure = Int(chunk[chunk.startIndex + 5].split(separator: " ").last!)!
                
                return Monkey(
                    items: items,
                    operation: { input in
                        let lhs = operation[2] == "old" ? input : Int(operation[2])!
                        return operation[1] == "+" ?
                            input + lhs :
                            input * lhs
                    },
                    test: test,
                    targetMonkey: { $0 % test == 0 ? testSuccess : testFailure }
                )
            }
    }
    
    func question1() -> Any {
        calculateMonkeyBusiness(rounds: 20) { $0 / 3 }
    }
    
    func question2() -> Any {
        let lcm = monkeys.map(\.test).reduce(1, *)
        return calculateMonkeyBusiness(rounds: 10000) { $0 % lcm }
    }
    
    private func calculateMonkeyBusiness(rounds: Int, manageWorryLevel: (Int) -> Int) -> Int {
        var monkeys = self.monkeys
        
        for _ in 0..<rounds {
            for i in 0..<monkeys.count {
                monkeys[i].inspectionCount += monkeys[i].items.count
                monkeys[i].items
                    .map(monkeys[i].operation)
                    .map(manageWorryLevel)
                    .forEach { monkeys[monkeys[i].targetMonkey($0)].items.append($0) }
                monkeys[i].items.removeAll()
            }
        }
        
        let sorted = monkeys.sorted { $0.inspectionCount > $1.inspectionCount }
        return sorted[0].inspectionCount * sorted[1].inspectionCount
    }
}
