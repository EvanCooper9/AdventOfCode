import AOCKit
import Algorithms

final class Day06: Solution {

    override func question1() -> Any {
        var visited = Set<Point>()
        var currentPoint = guardPoint
        var currentDirection: Direction = .up

        while input.contains(x: currentPoint.x, y: currentPoint.y) {
            visited.insert(currentPoint)

            let next = currentDirection.nextPoint(from: currentPoint)
            guard let tile = input[safe: next.y]?[safe: next.x] else { break }
            if tile == "#" {
                currentDirection = currentDirection.turn
                currentPoint = currentDirection.nextPoint(from: currentPoint)
            } else {
                currentPoint = next
            }
        }

        return visited.count
    }

    override func question2() -> Any {
        var visited = Set<Point>()
        var currentPoint = guardPoint
        var currentDirection: Direction = .up
        var obstacles = Set<Point>()

        while input.contains(x: currentPoint.x, y: currentPoint.y) {
            visited.insert(currentPoint)
            let next = currentDirection.nextPoint(from: currentPoint)
            guard let tile = input[safe: next.y]?[safe: next.x] else { break }
            if tile == "#" {
                currentDirection = currentDirection.turn
                currentPoint = currentDirection.nextPoint(from: currentPoint)
            } else {
                currentPoint = next
            }
        }

        var visitAgain = Set<Point>()
        currentPoint = guardPoint
        currentDirection = .up
        while input.contains(x: currentPoint.x, y: currentPoint.y) {
            visitAgain.insert(currentPoint)
            print(visitAgain.count)
            let next = currentDirection.nextPoint(from: currentPoint)

            guard let tile = input[safe: next.y]?[safe: next.x] else { break }
            if tile == "#" {
                currentDirection = currentDirection.turn
                currentPoint = currentDirection.nextPoint(from: currentPoint)
            } else {
                // pretend that next is an obstacle, see if it causes a loop
                var tempDirection = currentDirection.turn
                var tempPoint = tempDirection.nextPoint(from: currentPoint)
                while input.contains(x: tempPoint.x, y: tempPoint.y) {
                    guard tempPoint != currentPoint else {
                        // found a loop
                        obstacles.insert(next)
                        break
                    }
                    let tempNext = tempDirection.nextPoint(from: tempPoint)
                    guard let tempTile = input[safe: tempNext.y]?[safe: tempNext.x] else { break }
                    if tempTile == "#" {
                        tempDirection = tempDirection.turn
                        tempPoint = tempDirection.nextPoint(from: tempPoint)
                    } else {
                        tempPoint = tempNext
                    }
                }

                currentPoint = next
            }
        }

        return obstacles.count
    }

    private struct Turn: Hashable {
        let point: Point
        let direction: Direction
    }

    private enum Direction {
        case up, down, left, right

        func nextPoint(from point: Point) -> Point {
            switch self {
            case .up: return Point(x: point.x, y: point.y - 1)
            case .down: return Point(x: point.x, y: point.y + 1)
            case .left: return Point(x: point.x - 1, y: point.y)
            case .right: return Point(x: point.x + 1, y: point.y)
            }
        }

        var turn: Direction {
            switch self {
            case .up: return .right
            case .down: return .left
            case .left: return .up
            case .right: return .down
            }
        }
    }

    private var guardPoint: Point {
        for y in 0 ..< input.count {
            for x in 0 ..< input[y].count {
                if input[y][x] == "^" {
                    return Point(x: x, y: y)
                }
            }
        }
        fatalError()
    }
}
