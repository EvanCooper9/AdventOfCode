import AOCKit

final class Day02: Solution {

    private struct Game {
        typealias Block = String
        struct Pull {
            let count: Int
            let block: Block
        }
        typealias Turn = [Pull]
        
        let number: Int
        let turns: [Turn]
    }

    func question1() -> Any {
        let availableBlocks = ["red": 12, "green": 13, "blue": 14]

        return games
            .filter { game in
                game.turns.allSatisfy { turn in
                    turn.allSatisfy { pull in
                        pull.count <= availableBlocks[pull.block] ?? 0
                    }
                }
            }
            .map(\.number)
            .reduce(0, +)
    }
    
    func question2() -> Any {
        games
            .map { game in
                var mins = ["red": 0, "green": 0, "blue": 0]

                game.turns.forEach { turn in
                    turn.forEach { pull in
                        mins[pull.block] = max(mins[pull.block] ?? Int.max, pull.count)
                    }
                }

                return mins.values.reduce(1, *)
            }
            .reduce(0, +)
    }

    private lazy var games: [Game] = {
        input
            .compactMap { line -> Game? in
                let split = line.split(separator: ":")
                let gameNumber = split.first?.split(separator: " ").last?.toInt()
                let turns = split.last?.split(separator: ";").compactMap { turn -> Game.Turn? in
                    turn.split(separator: ",")
                        .map { string -> String in string.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .compactMap { blockPull -> Game.Pull? in
                            let split = blockPull.split(separator: " ")
                            let count = split.first?.toInt()
                            let color = split.last
                            guard let count, let color else { return nil }
                            return .init(count: count, block: String(color))
                        }
                }

                guard let gameNumber, let turns else { return nil }
                return Game(number: gameNumber, turns: turns)
            }
    }()
}
