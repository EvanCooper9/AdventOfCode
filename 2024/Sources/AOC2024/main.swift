import AOCKit
import Foundation

extension Solution {
    var rows: [String] {
        input
    }

    var cols: [String] {
        var columns = [String]()
        for x in 0 ..< input[0].count {
            var column = [Character]()
            for y in 0 ..< input.count {
                column.append(input[y][x])
            }
            columns.append(column.string)
        }
        return columns
    }
}

let start = CFAbsoluteTimeGetCurrent()
let day = Day12(bundle: .module)
let diff = CFAbsoluteTimeGetCurrent() - start
print("Loaded: \(type(of: day)) in:", diff, "s")
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
