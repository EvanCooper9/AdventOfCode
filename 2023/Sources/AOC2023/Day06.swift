import Algorithms
import AOCKit

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
        func findWinningIndex(in range: Range<Int>, highest: Bool) -> Int? {
            guard !range.isEmpty else { return nil }
            guard range.count > 1 else { return highest ? range.upperBound : range.lowerBound }
            let currentDistance = (time - range.mid) * range.mid
            if currentDistance > distance {
                let nextRangeToSearch = highest ? range.mid..<range.upperBound : range.lowerBound..<range.mid
                return findWinningIndex(in: nextRangeToSearch, highest: highest)
            } else {
                let nextRangeToSearch = highest ? range.lowerBound..<range.mid : range.mid..<range.upperBound
                return findWinningIndex(in: nextRangeToSearch, highest: highest)
            }
        }

        let lowestWinningIndex = (findWinningIndex(in: 1..<time, highest: false) ?? 0) + 1
        let highestWinningIndex = (findWinningIndex(in: 1..<time, highest: true) ?? 0) - 1
        return highestWinningIndex - lowestWinningIndex + 1
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
