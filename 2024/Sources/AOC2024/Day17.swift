import AOCKit
import Algorithms

final class Day17: Solution {
    override func question1() -> Any {
        let registers = input[0 ..< 3].map { line in
            line.matches(of: #/\d+/#).compactMap { line[$0.range].toInt() }.first!
        }

        let program = input[4]
            .matches(of: #/\d+/#)
            .compactMap { input[4][$0.range].toInt() }

        return run(program: program, registers: registers)
            .map(String.init)
            .joined(separator: ",")
    }
    
    override func question2() -> Any {
        0
    }

    private func run(program: [Int], registers: [Int], checkOutput: (([Int]) -> Bool)? = nil) -> [Int] {
        var registers = registers
        var output = [Int]()

        var instructionPointer = 0
        while instructionPointer < program.count {
            var jump = true
            defer {
                if jump {
                    instructionPointer += 2
                }
            }
            let opcode = program[instructionPointer]
            let operand = program[instructionPointer + 1]
            switch opcode {
            case 0:
                registers[0] = registers[0] / pow(2, combo(operand: operand, registers: registers))
            case 1:
                registers[1] = registers[1] ^ operand
            case 2:
                registers[1] = combo(operand: operand, registers: registers) % 8
            case 3:
                if registers[0] == 0 {
                    continue
                } else {
                    instructionPointer = operand
                    jump = false
                }
            case 4:
                registers[1] = registers[1] ^ registers[2]
            case 5:
                output.append(combo(operand: operand, registers: registers) % 8)
                if checkOutput?(output) == false {
                    return output
                }
            case 6:
                registers[1] = registers[0] / pow(2, combo(operand: operand, registers: registers))
            case 7:
                registers[2] = registers[0] / pow(2, combo(operand: operand, registers: registers))
            default:
                break
            }
        }

        return output
    }

    private func combo(operand: Int, registers: [Int]) -> Int {
        switch operand {
        case 0 ... 3: return operand
        case 4: return registers[0]
        case 5: return registers[1]
        case 6: return registers[2]
        case 7: fatalError("reserved operand \(operand)")
        default: fatalError("unexpected operand \(operand)")
        }
    }
}
