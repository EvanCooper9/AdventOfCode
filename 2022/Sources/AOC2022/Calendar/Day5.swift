import AOCKit

struct Day5: Solution {

    private let stacks: [[Character]] = {
        var stacks = Array(repeating: [Character](), count: 9)
        for line in lines(for: "day5", in: .module) {
            guard line.prefix(2) != " 1" else { break }
            var currentStack = 0
            for i in stride(from: 1, to: line.count, by: 4) {
                defer { currentStack += 1 }
                let item = line[line.index(line.startIndex, offsetBy: i)]
                guard item != " " else { continue }
                stacks[currentStack].append(item)
            }
        }
        return stacks
    }()
    
    private let moves: [(Int, Int, Int)] = {
        lines(for: "day5", in: .module).compactMap { line in
            guard line.starts(with: "move") else { return nil }
            let numbers = line
                .components(separatedBy: " ")
                .compactMap { Int($0) }
            return (numbers[0], numbers[1], numbers[2])
        }
    }()
    
    func question1() -> Any {
        var stacks = stacks
        moves.forEach { count, from, to in
            (0..<count).forEach { _ in
                let character = stacks[from - 1].removeFirst()
                stacks[to - 1].insert(character, at: 0)
            }
        }
        return stacks
            .compactMap(\.first)
            .reduce("") { $0 + "\($1)" }
    }
    
    func question2() -> Any {
        var stacks = stacks
        moves.forEach { count, from, to in
            let characters = stacks[from - 1][0..<count]
            stacks[from - 1].removeFirst(count)
            stacks[to - 1].insert(contentsOf: characters, at: 0)
        }
        return stacks
            .compactMap(\.first)
            .reduce("") { $0 + "\($1)" }
    }
}
