import Algorithms
import AOCKit
import Darwin

final class Day04: Solution {

    func question1() -> Any {
        cards
            .map(\.points)
            .reduce(0, +)
    }
    
    func question2() -> Any {
        var cardCountByIndex = Dictionary(uniqueKeysWithValues: cards.indices.map { ($0, 1) })

        cards.enumerated().forEach { currentCardIndex, currentCard in
            let currentCardCount = cardCountByIndex[currentCardIndex]!
            for indexWon in (currentCardIndex + 1)..<(currentCardIndex + 1 + currentCard.matchingNumbers) {
                cardCountByIndex[indexWon] = cardCountByIndex[indexWon]! + currentCardCount
            }
        }

        return cardCountByIndex
            .values
            .reduce(0, +)
    }

    init() {
        cards = input.map(Card.init)
    }

    private struct Card {
        let matchingNumbers: Int
        let points: Int

        init(_ line: String) {
            let numbers = line.split(separator: ":")[1]
            let winningNumbers = numbers
                .split(separator: "|")[0]
                .split(separator: " ")
                .compactMap { Int($0) }
            let myNumbers = numbers
                .split(separator: "|")[1]
                .split(separator: " ")
                .compactMap { Int($0) }

            matchingNumbers = winningNumbers
                .filter { myNumbers.contains($0) }
                .count
            points = Int(pow(Double(2), Double(matchingNumbers - 1)))
        }
    }

    private var cards = [Card]()
}
