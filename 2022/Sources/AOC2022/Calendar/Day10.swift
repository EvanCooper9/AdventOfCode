import Algorithms
import AOCKit

struct Day10: Solution {
    
    private struct Instruction {
        var cycles: Int
        let action: ((inout Int) -> Void)?
    }
    
    private let instructions: [Instruction] = {
        lines(for: "day10", in: .module).compactMap { line in
            let components = line.components(separatedBy: " ")
            if components.first == "noop" {
                return Instruction(cycles: 1, action: nil)
            } else if let value = Int(components.last!) {
                return Instruction(cycles: 2) { $0 += value }
            }
            return nil
        }
    }()
    
    func question1() -> Any {
        var register = 1
        var sum = 0
        var currentCycle = 0
        var nextInterestedCycle = 20
        for instruction in instructions {
            for _ in 0..<instruction.cycles {
                currentCycle += 1
                guard currentCycle == nextInterestedCycle else { continue }
                sum += register * currentCycle
                nextInterestedCycle += 40
            }
            instruction.action?(&register)
        }
        return sum
    }
    
    func question2() -> Any {
        var screen = [String]()
        
        var sprite = 1
        var currentCycle = 0
        for instruction in instructions {
            for _ in 0..<instruction.cycles {
                currentCycle += 1
                let position = (currentCycle - 1) % 40
                if ((sprite - 1)...(sprite + 1)).contains(position) {
                    screen.append("#")
                } else {
                    screen.append(".")
                }
            }
            instruction.action?(&sprite)
        }
        
        return "\n" + screen
            .chunks(ofCount: 40)
            .map { $0.joined() }
            .joined(separator: "\n")
    }
}
