import Algorithms
import AOCKit

final class Day10: Solution {

    func question1() -> Any {

        var maxDistances = Array(repeating: Array(repeating: Int.max, count: grid[0].count), count: grid.count)

        func adjacentValidPoints(to point: Point) -> [Point] {
            let top: Point? = {
                guard let character = grid[safe: point.y - 1]?[safe: point.x],
                      ["|", "7", "F"].contains(character) else { 
                    return nil
                }
                return Point(x: point.x, y: point.y - 1)
            }()
            let bottom: Point? = {
                guard let character = grid[safe: point.y + 1]?[safe: point.x],
                      ["|", "L", "J"].contains(character) else {
                    return nil
                }
                return Point(x: point.x, y: point.y + 1)
            }()
            let left: Point? = {
                guard let character = grid[safe: point.y]?[safe: point.x - 1],
                      ["-", "L", "F"].contains(character) else {
                    return nil
                }
                return Point(x: point.x - 1, y: point.y)
            }()
            let right: Point? = {
                guard let character = grid[safe: point.y]?[safe: point.x + 1],
                      ["-", "7", "J"].contains(character) else {
                    return nil
                }
                return Point(x: point.x + 1, y: point.y)
            }()
            return [top, bottom, left, right].compactMap { $0 }
        }

        var pointsToCheck = [start]
        maxDistances[start.y][start.x] = 0
        while !pointsToCheck.isEmpty {
            let currentPoint = pointsToCheck.removeFirst()
            let currentDistance = maxDistances[currentPoint.y][currentPoint.x] + 1

            for point in adjacentValidPoints(to: currentPoint) {
                let maxDistanceToPoint = maxDistances[point.y][point.x]

                if maxDistanceToPoint > currentDistance {
                    maxDistances[point.y][point.x] = currentDistance
                    pointsToCheck.append(point)
                }
            }
        }

        return maxDistances
            .compactMap { distances in
                distances.filter { $0 != Int.max }.max()
            }
            .max()!
    }

    func question2() -> Any {
        0
    }

    init() {
        input.forEach { line in
            grid.append(line.characters)
        }
    }

    private struct Point: Equatable {
        let x: Int
        let y: Int
    }

    private var grid = [[Character]]()
    private lazy var start: Point = {
        for (indexY, line) in input.enumerated() {
            for (indexX, character) in line.enumerated() {
                if character == "S" {
                    return Point(x: indexX, y: indexY)
                }
            }
        }
        fatalError()
    }()
}

extension String {
    var characters: [Character] {
        var characters = [Character]()
        forEach { characters.append($0) }
        return characters
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? where Index == Int {
        guard (0..<count).contains(index) else { return nil }
        return self[index]
    }
}
