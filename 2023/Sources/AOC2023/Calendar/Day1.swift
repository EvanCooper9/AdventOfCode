import AOCKit

struct Day1: Solution {

    private let digits = (0...9).map { "\($0)" }
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
        var sum = 0
        
        func number(in line: String) -> String? {
            for character in line {
                let stringCharacter = String(character)
                if digits.contains(stringCharacter) {
                    return stringCharacter
                }
            }
            return nil
        }

        for line in lines(for: "day1", in: .module) {
            let first = number(in: line)
            let last = number(in: String(line.reversed()))

            guard let first, let last, let number = Int(first + last) else { continue }
            sum += number
        }

        return sum
    }

    func question2() -> Any {
        var sum = 0

        func number(in line: String, reversed: Bool) -> String? {
            var buffer = ""
            for character in line {
                let stringCharacter = String(character)
                if digits.contains(stringCharacter) {
                    return stringCharacter
                } else {
                    buffer += String(character)
                    if reversed {
                        let reversedBuffer = String(buffer.reversed())
                        if let match = speltDigits.first(where: { key, _ in reversedBuffer.contains(key) }) {
                            return match.value
                        }
                    } else {
                        if let match = speltDigits.first(where: { key, _ in buffer.contains(key) }) {
                            return match.value
                        }
                    }
                }
            }
            return nil
        }

        for line in lines(for: "day1", in: .module) {
            let first = number(in: line, reversed: false)
            let last = number(in: String(line.reversed()), reversed: true)

            guard let first, let last, let number = Int(first + last) else { continue }
            sum += number
        }

        return sum
    }
}
