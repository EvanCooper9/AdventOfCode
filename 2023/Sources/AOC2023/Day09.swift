import Algorithms
import AOCKit

final class Day09: Solution {

    func question1() -> Any {
        prediction(side: .back)
    }
    
    func question2() -> Any {
        prediction(side: .front)
    }

    init() {
        histories = input.map { line in
            line.split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
        }
    }

    private func prediction(side: Side) -> Int {
        histories
            .map { history in
                var steps = [history]
                while steps.last?.allSatisfy({ $0 == 0 }) != true {
                    let previousSteps = steps.last!
                    var currentSteps = [Int]()
                    for i in 1..<previousSteps.count {
                        currentSteps.append(previousSteps[i] - previousSteps[i - 1])
                    }
                    steps.append(currentSteps)
                }

                let predictedLine = steps
                    .reversed()
                    .reduce([0]) { previousStep, step in
                        switch side {
                        case .front:
                            let newValue = step.first! - previousStep.first!
                            return [newValue] + step
                        case .back:
                            let newValue = previousStep.last! + step.last!
                            return step + [newValue]
                        }
                    }

                switch side {
                case .front:
                    return predictedLine.first!
                case .back:
                    return predictedLine.last!
                }
            }
            .reduce(0, +)
    }

    private enum Side {
        case front, back
    }

    private var histories = [[Int]]()
}
