import AOCKit
import Algorithms
import Foundation

final class Day16: Solution {
    
    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        grid = Array(input.map(\.characters))
        scores = Array(repeating: Array(repeating: Int.max, count: input[0].count), count: input.count)
        scores2 = Array(repeating: Array(repeating: Set<Int>(), count: input[0].count), count: input.count)
    }
    
    override func question1() -> Any {
        guard let start = find("S"), let end = find("E") else {
            fatalError("Couldn't find start or end")
        }
        
        scores[start.y][start.x] = 0
        scores2[start.y][start.x].insert(0)
        score(start, end, .right)

        return scores[end.y][end.x]
    }
    
    override func question2() -> Any {
        guard let start = find("S"), let end = find("E") else {
            fatalError("Couldn't find start or end")
        }

        let points = walk(current: end, target: start, direction: .down, currentScore: scores[end.y][end.x])
        return points.count + 1
    }
    
    private var grid = [[Character]]()
    private var scores = [[Int]]()
    private var scores2 = [[Set<Int>]]()

    private func score(_ current: Point, _ end: Point, _ direction: Direction) {
        guard current != end else { return }

        let routes: [Direction: Point] = [
            .up: current.up,
            .down: current.down,
            .left: current.left,
            .right: current.right
        ]
        
        for (routeDirection, routePoint) in routes {
            guard grid.contains(point: routePoint) && grid[routePoint.y][routePoint.x] != "#" else { continue }
            let stepScore = routeDirection == direction ? 1 : 1001
            let routeScore = scores[current.y][current.x] + stepScore
            scores2[routePoint.y][routePoint.x].insert(routeScore)
            if routeScore < scores[routePoint.y][routePoint.x] {
                scores[routePoint.y][routePoint.x] = routeScore
                score(routePoint, end, routeDirection)
            }
        }
    }

    private func walk(current: Point, target: Point, direction: Direction, currentScore: Int, previous: Set<Point> = []) -> Set<Point> {
        guard current != target else { return previous }

        let routes: [Direction: Point] = [
            .up: current.up,
            .down: current.down,
            .left: current.left,
            .right: current.right
        ]

        let points = routes
            .filter { grid.contains(point: $1) && grid[$1.y][$1.x] != "#" && !previous.contains($1) }
            .map { routeDirection, routePoint -> Set<Point> in
                let stepScore = routeDirection == direction ? 1 : 1001
                let routeScore = currentScore - stepScore
                let scores = scores2[routePoint.y][routePoint.x]
                guard scores.contains(routeScore) || scores.contains(routeScore - 1000) || scores.contains(routeScore + 1000) else { return [] }
                let visited = previous.union([routePoint])
                let points = walk(current: routePoint, target: target, direction: routeDirection, currentScore: routeScore, previous: visited)
                return points
            }
            .flattened()

        return Set(points)
    }

    private func find(_ character: Character) -> Point? {
        for y in 0 ..< input.count {
            for x in 0 ..< input[y].count {
                if input[y][x] == character {
                    return Point(x: x, y: y)
                }
            }
        }
        return nil
    }
}
