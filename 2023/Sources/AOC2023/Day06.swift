import Algorithms
import AOCKit
import Darwin

final class Day06: Solution {

    func question1() -> Any {
        let times = getNumbers(from: input[0], withKering: false)
        let distances = getNumbers(from: input[1], withKering: false)
        return zip(times, distances)
            .map { waysToWinRace(time: $0, distance: $1) }
            .reduce(1, *)
    }
    
    func question2() -> Any {
        let time = getNumbers(from: input[0], withKering: true).first!
        let distance = getNumbers(from: input[1], withKering: true).first!
        return waysToWinRace(time: time, distance: distance)
    }

    private func waysToWinRace(time: Int, distance: Int) -> Int {
        func getFirstCanWinIndex(reversed: Bool) -> Int? {
            for i in 1..<time {
                let buttonHoldDownTime = reversed ? (time - i) : i
                let currentDistance = (time - buttonHoldDownTime) * buttonHoldDownTime
                guard currentDistance > distance else { continue }
                return buttonHoldDownTime
            }
            return nil
        }

        guard let minCanWinIndex = getFirstCanWinIndex(reversed: false),
              let maxCanWinIndex = getFirstCanWinIndex(reversed: true) else { return 0 }
        return maxCanWinIndex - minCanWinIndex + 1
    }

    private func getNumbers(from line: String, withKering: Bool) -> [Int] {
        let numbers = line
            .split(separator: " ")
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        if withKering {
            let number = numbers.joined().toInt()!
            return [number]
        } else {
            return numbers.compactMap { Int($0) }
        }
    }
}
