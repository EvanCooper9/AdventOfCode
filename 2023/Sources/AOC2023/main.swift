import AOCKit
import Foundation

extension Solution {
    var input: [String] {
        guard let type = "\(type(of: self))".split(separator: ".").last else { return [] }
        return AOCKit.lines(for: String(type), in: .module)
    }
}

let day = Day13()
print("Running: \(type(of: day))")

func run(_ function: () -> Any) {
    let start = CFAbsoluteTimeGetCurrent()
    let ans = function()
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Answer:", ans)
    print("Ran in:", diff, "s")
}

print("== Question 1 ==")
run(day.question1)

print("== Question 2 ==")
run(day.question2)
