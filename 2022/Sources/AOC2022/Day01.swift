import AOCKit

struct Day1: Solution {

    private let elves: [Int] = {
        var current = 0
        var elves = [Int]()
        lines(for: "day1", in: .module).forEach { line in
            guard !line.isEmpty else {
                elves.append(current)
                current = 0
                return
            }
            guard let calories = Int(line) else { return }
            current += calories
        }
        return elves.sorted()
    }()
    
    func question1() -> Any {
        elves.last!
    }
    
    func question2() -> Any {
        elves.suffix(3).reduce(0, +)
    }
}
