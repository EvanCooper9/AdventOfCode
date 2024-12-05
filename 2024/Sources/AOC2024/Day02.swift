import AOCKit
import Algorithms

final class Day02: Solution {
    override func question1() -> Any {
        reports
            .filter(validate)
            .count
    }

    override func question2() -> Any {
        reports
            .filter { report in
                if validate(report) {
                    return true
                }

                var indiciesToRemove = Array(report.indices).map(Int?.init)
                indiciesToRemove.insert(nil, at: 0)
                return report.indices.contains { index in
                    var currentReport = report
                    currentReport.remove(at: index)
                    return validate(currentReport)
                }
            }
            .count
    }

    private var reports: [[Int]] {
        input.map { report in
            report.split(separator: " ").compactMap { $0.toInt() }
        }
    }

    private func validate(_ report: [Int]) -> Bool {
        let increasing = report[0] < report[1]
        return report.adjacentPairs().allSatisfy { left, right in
            let trend = increasing ? left < right : right < left
            let diff = (1...3).contains(abs(left - right))
            return trend && diff
        }
    }
}
