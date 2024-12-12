import AOCKit
import Algorithms
import Foundation

final class Day12: Solution {

    private var regions = [Region]()
    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        regions = makeRegions()
    }

    override func question1() -> Any {
        regions
            .map { $0.area * $0.perimeter }
            .sum
    }

    override func question2() -> Any {
        regions
            .map { $0.area * $0.sides }
            .sum
    }

    private func makeRegions() -> [Region] {
        var seen = Set<Point>()
        var regions = [Region]()

        for y in 0 ..< input.count {
            for x in 0 ..< input[y].count {
                let point = Point(x: x, y: y)
                guard !seen.contains(point) else { continue }
                let region = region(from: point, current: [point])
                seen = seen.union(region)
                regions.append(region)
            }
        }

        return regions
    }

    private var cache = [Point: Region]()
    private func region(from point: Point, current: Region = []) -> Region {
        if let cached = cache[point] { return cached }
        var current = current
        current.insert(point)

        let left = Point(x: point.x - 1, y: point.y)
        let right = Point(x: point.x + 1, y: point.y)
        let up = Point(x: point.x, y: point.y - 1)
        let down = Point(x: point.x, y: point.y + 1)

        [left, right, up, down]
            .compactMap { adjacentPoint -> Set<Point>? in
                guard !current.contains(adjacentPoint) else { return nil }
                guard input.contains(point: adjacentPoint) else { return nil }
                guard input[adjacentPoint.y][adjacentPoint.x] == input[point.y][point.x] else { return nil }

                current.insert(adjacentPoint)
                let adjacentRegion = region(from: adjacentPoint, current: current)
                return adjacentRegion
            }
            .forEach { current = current.union($0) }

        cache[point] = current
        return current
    }
}

private typealias Region = Set<Point>
private extension Region {

    var area: Int { count }

    var perimeter: Int {
        reduce(0) { perimeter, point in
            let sharedEdges = [point.left, point.right, point.up, point.down]
                .filter(contains)
                .count
            return perimeter + 4 - sharedEdges
        }
    }

    var sides: Int {
        var edges = Set<Edge>()
        forEach { point in
            if !contains(point.left) {
                edges.insert(Edge(point: point, side: .left))
            }
            if !contains(point.right) {
                edges.insert(Edge(point: point, side: .right))
            }
            if !contains(point.up) {
                edges.insert(Edge(point: point, side: .up))
            }
            if !contains(point.down) {
                edges.insert(Edge(point: point, side: .down))
            }
        }

        var sides = 0
        Direction.allCases.forEach { direction in
            for i in direction.range(from: edges) {
                let filtered = edges
                    .filter { $0.side == direction && $0.point[keyPath: direction.filterKeyPath] == i }
                    .sorted { $0.point[keyPath: direction.sortKeyPath] < $1.point[keyPath: direction.sortKeyPath] }
                guard let first = filtered.first else { continue }
                sides += 1
                var currentPoint = first.point
                for edge in filtered[1...] {
                    defer { currentPoint = edge.point }
                    guard currentPoint[keyPath: direction.sortKeyPath] + 1 != edge.point[keyPath: direction.sortKeyPath] else { continue }
                    sides += 1
                }
            }
        }
        return sides
    }
}

private struct Edge: Hashable {
    let point: Point
    let side: Direction
}

private enum Direction: CaseIterable {
    case up, down, left, right

    func range(from edges: any Collection<Edge>) -> ClosedRange<Int> {
        switch self {
        case .up, .down: return 0 ... edges.map(\.point.y).max()!
        case .left, .right: return 0 ... edges.map(\.point.x).max()!
        }
    }

    var filterKeyPath: KeyPath<Point, Int> {
        switch self {
        case .up, .down: return \.y
        case .left, .right: return \.x
        }
    }

    var sortKeyPath: KeyPath<Point, Int> {
        switch self {
        case .up, .down: return \.x
        case .left, .right: return \.y
        }
    }
}
