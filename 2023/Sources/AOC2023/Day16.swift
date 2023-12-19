import Algorithms
import AOCKit

final class Day16: Solution {

    func question1() -> Any {
        energizedTiles(startingFrom: -1, y: 0, inDirection: .right)
    }

    func question2() -> Any {
        let maxYs = (0..<grid.count).map { y in
            let leading = energizedTiles(startingFrom: -1, y: y, inDirection: .right)
            let trailing = energizedTiles(startingFrom: grid[0].count, y: y, inDirection: .left)
            return max(leading, trailing)
        }
        .max()!

        let maxXs = (0..<grid[0].count).map { x in
            let top = energizedTiles(startingFrom: x, y: -1, inDirection: .down)
            let bottom = energizedTiles(startingFrom: x, y: grid.count, inDirection: .up)
            return max(top, bottom)
        }
        .max()!

        return max(maxYs, maxXs)
    }

    init() {
        grid = input.map { $0.compactMap(GridItem.init) }
    }

    private func energizedTiles(startingFrom x: Int, y: Int, inDirection direction: Direction) -> Int {
        var cache = Set<String>()
        var visited = Array(repeating: Array(repeating: false, count: grid[0].count), count: grid.count)
        moveFrom(x: x, y: y, in: direction, visited: &visited, cache: &cache)
        return visited.map { row in row.filter({ $0 }).count }.sum
    }

    private func moveFrom(x: Int, y: Int, in direction: Direction, visited: inout [[Bool]], cache: inout Set<String>) {
        let key = "\(x)-\(y)-\(direction.rawValue)"
        guard !cache.contains(key) else {
            return
        }
        cache.insert(key)

        var nextX = x
        var nextY = y
        switch direction {
        case .up: nextY -= 1
        case .down: nextY += 1
        case .left: nextX -= 1
        case .right: nextX += 1
        }

        guard (0..<grid.count).contains(nextY) && (0..<grid[0].count).contains(nextX) else { return }

        var nextDirections = [Direction]()
        switch grid[nextY][nextX] {
        case .empty: // = .
            nextDirections = [direction]
        case .verticalSplitter: // = |
            switch direction {
            case .up, .down: nextDirections = [direction]
            case .left, .right: nextDirections = [.up, .down]
            }
        case .horizontalSplitter: // = -
            switch direction {
            case .up, .down: nextDirections = [.left, .right]
            case .left, .right: nextDirections = [direction]
            }
        case .leftMirror: // = \
            switch direction {
            case .up: nextDirections = [.left]
            case .down: nextDirections = [.right]
            case .left: nextDirections = [.up]
            case .right: nextDirections = [.down]
            }
        case .rightMirror: // = /
            switch direction {
            case .up: nextDirections = [.right]
            case .down: nextDirections = [.left]
            case .left: nextDirections = [.down]
            case .right: nextDirections = [.up]
            }
        }

        visited[nextY][nextX] = true
        nextDirections.forEach {
            moveFrom(x: nextX, y: nextY, in: $0, visited: &visited, cache: &cache)
        }
    }

    private enum Direction: String {
        case up, down, left, right

        var horizontal: Bool {
            switch self {
            case .left, .right: return true
            case .up, .down: return false
            }
        }
    }

    private enum GridItem: Character {
        case empty = "."
        case verticalSplitter = "|"
        case horizontalSplitter = "-"
        case rightMirror = "/"
        case leftMirror = #"\"#
    }

    private var grid = [[GridItem]]()
}
