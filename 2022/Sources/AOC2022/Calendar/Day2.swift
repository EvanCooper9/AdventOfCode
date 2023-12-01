import AOCKit

struct Day2: Solution {

    private enum Shape: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
        
        init?(_ input: String) {
            switch input {
            case "A":
                self = .rock
            case "B":
                self = .paper
            case "C":
                self = .scissors
            default:
                return nil
            }
        }
        
        var score: Int { rawValue }
        
        var losingShape: Shape {
            switch self {
            case .rock:
                return .scissors
            case .paper:
                return .rock
            case .scissors:
                return .paper
            }
        }
        
        var winningShape: Shape {
            switch self {
            case .rock:
                return .paper
            case .paper:
                return .scissors
            case .scissors:
                return .rock
            }
        }
    }
    
    private let rounds: [(Shape, String)] = {
        lines(for: "day2", in: .module).compactMap { round in
            let parts = round.components(separatedBy: " ")
            guard let opponent = Shape(parts[0]) else { return nil }
            return (opponent, parts[1])
        }
    }()

    func question1() -> Any {
        rounds.reduce(into: 0) { points, result in
            let (opponent, move) = result

            let player: Shape
            if move == "X" { // rock
                player = .rock
            } else if move == "Y" { // paper
                player = .paper
            } else if move == "Z" { // scissors
                player = .scissors
            } else {
                return
            }
            
            switch (opponent, player) {
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors): // draw
                points += 3
            case (.rock, .paper), (.paper, .scissors),  (.scissors, .rock): // win
                points += 6
            default: // lose
                break
            }
            points += player.score
        }
    }
    
    func question2() -> Any {
        rounds.reduce(into: 0) { points, result in
            let (opponent, desiredOutcome) = result
            if desiredOutcome == "X" { // lose
                points += opponent.losingShape.score
            } else if desiredOutcome == "Y" { // draw
                points += opponent.score + 3
            } else if desiredOutcome == "Z" { // win
                points += opponent.winningShape.score + 6
            }
        }
    }
}
