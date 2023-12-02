import AOCKit

struct Day01: Solution {

    func question1() -> Any {
        result { line, _ in
            line.compactMap(\.wholeNumberValue).first
        }
    }

    func question2() -> Any {
        let speltDigits = ["zero": 0, "one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9]
        return result { line, reversed in
            var buffer = [Character]()
            for character in line {
                if let number = character.wholeNumberValue {
                    return number
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
    }

    private func result(lineHandler: (String, Bool) -> Int?) -> Int {
        input.reduce(into: 0) { partialSum, line in
            let first = lineHandler(line, false)
            let second = lineHandler(String(line.reversed()), true)
            if let first, let second {
                partialSum += (first * 10) + second
            }
        }
    }
}
