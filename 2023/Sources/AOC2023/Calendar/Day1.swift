import AOCKit

struct Day1: Solution {

    private let digits = (0...9).map { Character("\($0)") }
    private let speltDigits = [
        "one": "1",
        "two": "2",
        "three": "3",
        "four": "4",
        "five": "5",
        "six": "6",
        "seven": "7",
        "eight": "8",
        "nine": "9"
    ]

    func question1() -> Any {
        func number(in line: String) -> String? {
            for character in line {
                if digits.contains(character) {
                    return String(character)
                }
            }
            return nil
        }

        return lines(for: "day1", in: .module).reduce(into: 0) { partialSum, line in
            let first = number(in: line)
            let last = number(in: String(line.reversed()))

            if let first, let last, let number = Int(first + last) {
                partialSum += number
            }
        }
    }

    func question2() -> Any {
        func number(in line: String, reversed: Bool) -> String? {
            var buffer = [Character]()
            for character in line {
                if digits.contains(character) {
                    return String(character)
                } else {
                    buffer.append(character)
                    let stringBuffer = reversed ? String(buffer.reversed()) : String(buffer)
                    if let match = speltDigits.first(where: { key, _ in stringBuffer.contains(key) }) {
                        return match.value
                    }
                }
            }
            return nil
        }

        return lines(for: "day1", in: .module).reduce(into: 0) { partialSum, line in
            let first = number(in: line, reversed: false)
            let last = number(in: String(line.reversed()), reversed: true)

            if let first, let last, let number = Int(first + last) {
                partialSum += number
            }
        }
    }
}
