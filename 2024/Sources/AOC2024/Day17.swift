import AOCKit
import Algorithms

final class Day17: Solution {
    override func question1() -> Any {
        var output = [Int]()
        var a = input[0].matches(of: #/\d+/#).first!.result.int!
        var b = 0
        var c = 0
        while true {
            b = a % 8
            b = b ^ 2
            c = a >> b
            b = b ^ 3
            b = b ^ c
            output.append(b % 8)
            a = a >> 3
            if a == 0 { break }
        }
        return output
            .map(String.init)
            .joined(separator: ",")
    }
    
    override func question2() -> Any {
        let program = input[4]
            .matches(of: #/\d+/#)
            .compactMap(\.result.int)

        func find(program: [Int], ans: Int) -> Int? {
            guard !program.isEmpty else { return ans }
            var a = 0
            var b = 0
            var c = 0
            for i in 0 ... 7 {
                a = ans << 3 | i
                b = a % 8
                b = b ^ 2
                c = a >> b
                b = b ^ 3
                b = b ^ c
                if b % 8 == program.last {
                    guard let sub = find(program: program.dropLast(), ans: a) else {
                        continue
                    }
                    return sub
                }
            }
            return nil
        }

        return find(program: program, ans: 0)!
    }
}
