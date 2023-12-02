import AOCKit

struct Day4: Solution {

    struct Pair {
        let left: ClosedRange<Int>
        let right: ClosedRange<Int>
    }
    
    private let pairs: [Pair] = {
        lines(for: "day4", in: .module).compactMap { line in
            guard !line.isEmpty else { return nil }
            let ranges = line.components(separatedBy: ",")
            return Pair(left: .init(ranges.first!), right: .init(ranges.last!))
        }
    }()
    
    func question1() -> Any {
        pairs
            .filter { $0.left.contains($0.right) || $0.right.contains($0.left) }
            .count
    }
    
    func question2() -> Any {
        pairs
            .filter { $0.left.overlaps($0.right) }
            .count
    }
}

extension ClosedRange where Bound == Int {
    
    init(_ string: String) {
        let numbers = string.components(separatedBy: "-")
        let start = Int(numbers.first!)!
        let end = Int(numbers.last!)!
        self = ClosedRange(uncheckedBounds: (lower: start, upper: end))
    }
    
    func contains(_ range: ClosedRange) -> Bool {
        lowerBound >= range.lowerBound && upperBound <= range.upperBound
    }
}
