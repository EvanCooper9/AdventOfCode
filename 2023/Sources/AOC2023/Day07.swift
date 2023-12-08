import Algorithms
import AOCKit

final class Day07: Solution {

    func question1() -> Any {
        hands(wildcardJacks: false)
            .sorted()
            .map(\.bid)
            .enumerated()
            .map { ($0.offset + 1) * $0.element }
            .reduce(0, +)
    }
    
    func question2() -> Any {
        hands(wildcardJacks: true)
            .sorted()
            .enumerated()
            .map { ($0.offset + 1) * $0.element.bid }
            .reduce(0, +)
    }

    private func hands(wildcardJacks: Bool) -> [Hand] {
        input.map { line in
            let cards = line.split(separator: " ").first!.compactMap(Card.init)
            let bid = line.split(separator: " ").last!.toInt()!
            return Hand(cards: cards, bid: bid, wildcardJacks: wildcardJacks)
        }
    }

    struct Hand: Comparable {

        let cards: [Card]
        let bid: Int
        let wildcardJacks: Bool
        var value: Int

        init(cards: [Card], bid: Int, wildcardJacks: Bool) {
            self.cards = cards
            self.bid = bid
            self.wildcardJacks = wildcardJacks

            value = 1 // high card
            if hasSameCard(cards, count: 5) {
                value = 7 // five of a kind
            } else if hasSameCard(cards, count: 4) {
                value = 6 // four of a kind
            } else if isFullHouse {
                value = 5 // full house
            } else if hasSameCard(cards, count: 3) {
                value = 4 // three of a kind
            } else if isTwoPair {
                value = 3 // two pair
            } else if hasSameCard(cards, count: 2) {
                value = 2 // pair
            }
        }

        static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            if lhs.value < rhs.value {
                return true
            } else if lhs.value == rhs.value {
                // same hand
                for (lcard, rcard) in zip(lhs.cards, rhs.cards) {
                    if lcard.value(wildcardJacks: lhs.wildcardJacks) < rcard.value(wildcardJacks: rhs.wildcardJacks) {
                        return true
                    } else if lcard.value(wildcardJacks: lhs.wildcardJacks) > rcard.value(wildcardJacks: rhs.wildcardJacks) {
                        return false
                    }
                }
            }
            return false
        }

        private func hasSameCard(_ cards: [Card], count: Int) -> Bool {
            var cardCount = [Card: Int]()
            cards.forEach { card in
                cardCount[card] = (cardCount[card] ?? 0) + 1
            }

            if wildcardJacks {
                if count == 5 && cardCount[.jack] == count {
                    // special case where we have all jacks
                    return true
                }
                return cardCount
                    .mapValues { $0 + (cardCount[.jack] ?? 0) }
                    .filter { $0.key != .jack }
                    .values
                    .contains(count)
            } else {
                return cardCount
                    .values
                    .contains(count)
            }
        }

        private var isFullHouse: Bool {
            var cardCount = [Card: Int]()
            cards.forEach { card in
                cardCount[card] = (cardCount[card] ?? 0) + 1
            }
            if wildcardJacks {
                return cardCount.keys.count == 2 || (cardCount.keys.count == 3 && cardCount.keys.contains(.jack))
            } else {
                return cardCount.keys.count == 2
            }
        }

        private var isTwoPair: Bool {
            var cardCount = [Card: Int]()
            cards.forEach { card in
                cardCount[card] = (cardCount[card] ?? 0) + 1
            }
            if wildcardJacks {
                return cardCount.keys.count == 3 || (cardCount.keys.count == 4 && cardCount.keys.contains(.jack))
            } else {
                return cardCount.keys.count == 3
            }
        }
    }

    enum Card: Equatable, Hashable {
        case ace, king, queen, jack, ten, number(Int)

        init?(from character: Character) {
            switch character {
            case "A": self = .ace
            case "K": self = .king
            case "Q": self = .queen
            case "J": self = .jack
            case "T": self = .ten
            default:
                guard let number = Int(String(character)) else { return nil }
                self = .number(number)
            }
        }

        func value(wildcardJacks: Bool) -> Int {
            switch self {
            case .ace: return 14
            case .king: return 13
            case .queen: return 12
            case .jack: return wildcardJacks ? 1 : 11
            case .ten: return wildcardJacks ? 11 : 10
            case .number(let number): return wildcardJacks ? number + 1 : number
            }
        }
    }
}
