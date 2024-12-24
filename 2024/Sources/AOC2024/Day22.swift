import AOCKit
import Algorithms
import Foundation

final class Day22: Solution {
    override func question1() -> Any {
        input
            .map { buyerNumber in
                var number = Int(buyerNumber)!
                for _ in 1 ... 2000 {
                    number = next(from: number)
                }
                return number
            }
            .sum
    }
    
    override func question2() -> Any {
        var maxProfit = 0
        var sequencesAndPrices = [[Int]: Int]()
        input.forEach { buyerNumber in
            var number = Int(buyerNumber)!
            var priceHistory = [number % 10]
            var buyerSequences = Set<[Int]>()

            for i in 1 ... 2000 {
                number = next(from: number)
                let price = number % 10
                priceHistory.append(price)

                guard i >= 4 else { continue }
                let previousPrices = [
                    priceHistory[i - 3] - priceHistory[i - 4],
                    priceHistory[i - 2] - priceHistory[i - 3],
                    priceHistory[i - 1] - priceHistory[i - 2],
                    priceHistory[i] - priceHistory[i - 1]
                ]

                guard buyerSequences.insert(previousPrices).inserted else { continue }
                sequencesAndPrices[previousPrices, default: 0] += price
                maxProfit = max(maxProfit, sequencesAndPrices[previousPrices]!)
            }
        }

        return maxProfit
    }

    private func next(from number: Int) -> Int {
        var number = number
        number = ((number * 64) ^ number) % 16777216
        number = (Int((floor(Double(number) / 32.0))) ^ number) % 16777216
        number = ((number * 2048) ^ number) % 16777216
        return number
    }
}
