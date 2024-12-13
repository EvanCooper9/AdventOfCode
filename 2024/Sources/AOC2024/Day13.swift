import AOCKit
import Algorithms

final class Day13: Solution {
    override func question1() -> Any {
        tokens()
    }

    override func question2() -> Any {
        tokens(prizeFactor: 10000000000000)
    }

    private func tokens(prizeFactor: Int = 0) -> Int {
        input
            .chunks(ofCount: 4)
            .map { game in
                let joined = String(game.joined(by: "\n"))
                let numbers = joined
                    .matches(of:  #/\d+/#)
                    .compactMap { Double(joined[$0.range].toInt()!) }

                let buttonAX = numbers[0]
                let buttonAY = numbers[1]
                let buttonBX = numbers[2]
                let buttonBY = numbers[3]
                let prizeX = numbers[4] + Double(prizeFactor)
                let prizeY = numbers[5] + Double(prizeFactor)

                let slopeA = buttonAY / buttonAX
                let yInterceptA = prizeY - slopeA * prizeX
                let slopeB = buttonBY / buttonBX
                let yInterceptB = 0.0
                let xIntersection = (yInterceptB - yInterceptA) / (slopeA - slopeB)
                let bCount = xIntersection / buttonBX
                let aCount = (prizeX - xIntersection) / buttonAX

                guard aCount.isCloseToInt && bCount.isCloseToInt else { return 0 }
                return Int(aCount.rounded() * 3 + bCount.rounded())
            }
            .sum
    }
}

extension Double {
    var isCloseToInt: Bool {
        abs(self - rounded()) < 0.001
    }
}
