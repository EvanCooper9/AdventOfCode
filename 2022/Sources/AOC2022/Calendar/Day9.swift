import AOCKit

struct Day9: Solution {

    private final class Knot {
        
        var x: Int
        var y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func touching(_ knot: Knot) -> Bool {
            abs(knot.x - x) <= 1 && abs(knot.y - y) <= 1
        }
        
        func touch(_ head: Knot) {
            if y == head.y { // move horizontally
                x = head.x + (head.x > x ? -1 : 1)
            } else if x == head.x { // move vertically
                y = head.y + (head.y > y ? -1 : 1)
            } else { // move diagonally
                let xDiff = abs(head.x - x)
                let yDiff = abs(head.y - y)
                if xDiff > yDiff {
                    y = head.y
                    x = head.x + (head.x > x ? -1 : 1)
                } else if yDiff > xDiff {
                    x = head.x
                    y = head.y + (head.y > y ? -1 : 1)
                } else {
                    y = head.y + (head.y > y ? -1 : 1)
                    x = head.x + (head.x > x ? -1 : 1)
                }
            }
        }
    }
    
    private let moves: [(String, Int)] = {
        lines(for: "day9", in: .module).compactMap { input in
            let components = input.components(separatedBy: " ")
            return (components.first!, Int(components.last!)!)
        }
    }()
    
    func question1() -> Any {
        handle(knotCount: 2)
    }
    
    func question2() -> Any {
        handle(knotCount: 10)
    }
    
    private func handle(knotCount: Int) -> Int {
        var visitedByTail = [(Int, Int)]()
        let knots = (0..<knotCount).map { _ in Knot(x: 0, y: 0) }
        
        moves.forEach { direction, count in
            for _ in 1...count {
                switch direction {
                case "R":
                    knots[0].x += 1
                case "L":
                    knots[0].x -= 1
                case "U":
                    knots[0].y += 1
                case "D":
                    knots[0].y -= 1
                default:
                    break
                }
                
                for i in 1..<knots.count {
                    guard !knots[i].touching(knots[i - 1]) else { continue }
                    knots[i].touch(knots[i - 1])
                }
                
                let tail = knots.last!
                visitedByTail.append((tail.x, tail.y))
            }
        }
        
        return visitedByTail
            .reduce(into: [(Int, Int)]()) { partialResult, position in
                guard !partialResult.contains(where: { $0.0 == position.0 && $0.1 == position.1 }) else { return }
                partialResult.append(position)
            }
            .count
    }
}
