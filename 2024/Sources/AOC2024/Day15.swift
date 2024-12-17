import AOCKit
import Algorithms
import Foundation

final class Day15: Solution {

    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        let split = input.firstIndex(of: "")!
        grid = Array(input[..<split].map(\.characters))
        movements = Array(input[split...])
            .map { string in
                string.compactMap { character -> Direction? in
                    switch (character) {
                    case "^": return .up
                    case "v": return .down
                    case "<": return .left
                    case ">": return .right
                    default: return nil
                    }
                }
            }
            .flattened()
    }

    override func question1() -> Any {
        var grid = grid
        var robot = robot(grid: grid)
        grid[robot.y][robot.x] = "."

        for movement in movements {
            let expected = robot.next(direction: movement)

            guard grid[expected.y][expected.x] != "#" else { continue }
            guard grid[expected.y][expected.x] == "O" else {
                robot = expected
                continue
            }

            let horizontalShift = switch movement {
            case .up, .down: 0
            case .left: -1
            case .right: 1
            }

            let verticalShift = switch movement {
            case .up: -1
            case .down: 1
            case .left, .right: 0
            }

            let xRange: any Collection<Int> = switch movement {
            case .up, .down: Array(repeating: expected.x, count: grid[expected.y].count)
            case .left: (1 ... expected.x).reversed()
            case .right: (expected.x ..< grid[expected.y].count)
            }

            let yRange: any Collection<Int> = switch movement {
            case .up: (1 ... expected.y).reversed()
            case .down: (expected.y ..< grid.count)
            case .left, .right: Array(repeating: expected.y, count: grid.count)
            }

            var endX = expected.x
            var endY = expected.y
            for (x, y) in zip(Array(xRange), Array(yRange)) {
                guard grid[y][x] != "#" else { break }
                guard grid[y][x] == "." else { continue }
                endY = y
                endX = x
                break
            }

            if expected.y != endY {
                let shift = movement == .up ? -1 : 1
                let range: any Collection<Int> = movement == .up ? (endY ... expected.y) : (expected.y ... endY).reversed()
                for y in range {
                    grid[y][expected.x] = grid[y - shift][expected.x]
                }
                robot.y += shift
            } else if expected.x != endX {
                let shift = movement == .left ? -1 : 1
                grid[expected.y].remove(at: endX)
                grid[expected.y].insert(".", at: robot.x)
                robot.x += shift
            }
        }

        return result(grid: grid, boxEdge: "O")
    }
    
    override func question2() -> Any {
        var grid = grid.map { characters -> [Character] in
            characters.map { character -> [Character] in
                switch character {
                case "#": return ["#", "#"]
                case "O": return ["[", "]"]
                case ".": return [".", "."]
                case "@": return ["@", "."]
                default: return []
                }
            }
            .flattened()
        }

        func canMove(from point: Point, direction: Direction) -> Bool {
            switch direction {
            case .up, .down:
                let shift = direction == .up ? -1 : 1
                let nextPoint = Point(x: point.x, y: point.y + shift)
                guard grid.contains(point: nextPoint) else { return false }
                var nextPoints = [nextPoint]
                if "[]".contains(grid[nextPoint.y][nextPoint.x]) {
                    let horizontalShift = grid[nextPoint.y][nextPoint.x] == "[" ? 1 : -1
                    nextPoints.append(Point(x: point.x + horizontalShift, y: point.y + shift))
                }
                return nextPoints.allSatisfy { point in
                    switch grid[point.y][point.x] {
                    case ".": return true
                    case "#": return false
                    default: return canMove(from: point, direction: direction)
                    }
                }
            case .left, .right:
                let shift = direction == .left ? -1 : 1
                switch grid[safe: point.y]?[safe: point.x + shift] {
                case ".": return true
                case "#": return false
                default: return canMove(from: Point(x: point.x + shift, y: point.y), direction: direction)
                }
            }
        }

        func connectedPoints(from point: Point, direction: Direction) -> Set<Point> {
            guard "[]".contains(grid[point.y][point.x]) else { return [] }
            let verticalShift = direction == .up ? -1 : 1
            let horizontalShift = grid[point.y][point.x] == "[" ? 1 : -1
            let nextPoints = [
                    Point(x: point.x, y: point.y + verticalShift),
                    Point(x: point.x + horizontalShift, y: point.y + verticalShift)
                ]
                .filter { point in
                    switch grid[point.y][point.x] {
                    case ".", "#": return false
                    default: return true
                    }
                }
                .map { connectedPoints(from: $0, direction: direction) }
                .flattened()

            let sibling = Point(x: point.x + horizontalShift, y: point.y)
            return Set(nextPoints + [point, sibling])
        }

        func move(from point: Point, direction: Direction) {
            switch direction {
            case .up, .down:
                let shift = direction == .up ? -1 : 1
                let connectedPoints = connectedPoints(from: point, direction: direction)
                connectedPoints
                    .sorted { direction == .up ? $0.y < $1.y : $0.y > $1.y }
                    .forEach { point in
                        grid[point.y + shift][point.x] = grid[point.y][point.x]
                        grid[point.y][point.x] = "."
                    }
            case .right, .left:
                let shift = direction == .right ? 1 : -1
                var endX = point.x
                while "[]".characters.contains(grid[point.y][endX]) {
                    endX += shift
                }
                grid[point.y].remove(at: endX)
                grid[point.y].insert(".", at: point.x)
            }
        }

        var robot = robot(grid: grid)
        grid[robot.y][robot.x] = "."

        for movement in movements {
            guard canMove(from: robot, direction: movement) else { continue }
            robot = robot.next(direction: movement)
            move(from: robot, direction: movement)
        }

        return result(grid: grid, boxEdge: "[")
    }

    private var grid = [[Character]]()
    private var movements = [Direction]()

    private func robot(grid: [[Character]]) -> Point {
        for y in 0 ..< grid.count {
            for x in 0 ..< grid[y].count {
                if grid[y][x] == "@" {
                    return Point(x: x, y: y)
                }
            }
        }
        fatalError()
    }

    private func result(grid: [[Character]], boxEdge: Character) -> Int {
        var result = 0
        for y in 0 ..< grid.count {
            for x in 0 ..< grid[y].count {
                guard grid[y][x] == boxEdge else { continue }
                result += 100 * y + x
            }
        }
        return result
    }
}
