import AOCKit

extension Solution {
    var input: [String] {
        guard let type = "\(type(of: self))".split(separator: ".").last else { return [] }
        return AOCKit.lines(for: String(type), in: .module)
    }
}

let day = Day1()
print("Question 1:", day.question1())
print("Question 2:", day.question2())
