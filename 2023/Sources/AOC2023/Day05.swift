import Algorithms
import AOCKit
import Darwin

final class Day05: Solution {

    func question1() -> Any {
        let seeds = input
            .first!
            .split(separator: " ")
            .compactMap { Int($0) }

        return seeds
            .map { maps.reduce($0) { $1.transform(source: $0) } }
            .min()!
    }
    
    func question2() -> Any {
        let seedRanges = input
            .first!
            .split(separator: " ")
            .compactMap { Int($0) }
            .chunks(ofCount: 2)
            .map(Array.init)
            .map { ($0[0])..<($0[0] + $0[1]) }

        return maps
            .reduce(seedRanges) { $1.transform(ranges: $0) }
            .first!
            .lowerBound
    }

    init() {
        maps = input
            .dropFirst(2)
            .chunked { lhs, rhs in
                if !lhs.isEmpty && !rhs.isEmpty {
                    return true
                } else if lhs.isEmpty {
                    return false
                }
                return true
            }
            .map(Array.init)
            .map(Map.init)
    }

    private struct Line {
        let sourceRangeStart: Int
        var sourceRangeEnd: Int { sourceRangeStart + rangeLength }
        var sourceRange: Range<Int> { sourceRangeStart..<sourceRangeEnd }

        private let destinationRangeStart: Int
        private let rangeLength: Int

        init(_ line: String) {
            let numbers = line.split(separator: " ").map { Int($0)! }
            destinationRangeStart = numbers[0]
            sourceRangeStart = numbers[1]
            rangeLength = numbers[2]
        }

        func transform(source: Int) -> Int? {
            guard sourceRange.contains(source) else { return nil }
            return source + (destinationRangeStart - sourceRangeStart)
        }
    }

    private struct Map {
        
        private let lines: [Line]

        init(_ lines: [String]) {
            self.lines = lines
                .filter { $0.first?.isWholeNumber == true }
                .map(Line.init)
        }

        func transform(source: Int) -> Int {
            for line in lines {
                guard let transformed = line.transform(source: source) else { continue }
                return transformed
            }
            return source
        }

        func transform(ranges: [Range<Int>]) -> [Range<Int>] {
            ranges
                .map { range -> [Range<Int>] in
                    var rangesToConvert = [range]
                    var convertedRanges = [Range<Int>]()

                    for line in lines {
                        var newRanges = [Range<Int>]()
                        rangesToConvert.forEach { range in
                            if range.contains(line.sourceRangeStart) {
                                newRanges.append(range.lowerBound..<line.sourceRangeStart)
                            } else if range.upperBound < line.sourceRangeStart {
                                newRanges.append(range)
                            }
                            if range.contains(line.sourceRangeEnd - 1) {
                                newRanges.append(line.sourceRangeEnd..<range.upperBound)
                            } else if range.lowerBound >= line.sourceRangeEnd {
                                newRanges.append(range)
                            }

                            let clamped = range.clamped(to: line.sourceRange)
                            if let newStart = line.transform(source: clamped.lowerBound), let newEnd = line.transform(source: clamped.upperBound - 1), newStart != newEnd {
                                convertedRanges.append(newStart..<newEnd)
                            }
                        }
                        rangesToConvert = newRanges
                    }

                    return (convertedRanges + rangesToConvert).filter { !$0.isEmpty }
                }
                .flattened()
                .removingDuplicates()
                .sorted { $0.lowerBound < $1.lowerBound }
        }
    }

    private var maps = [Map]()
}
