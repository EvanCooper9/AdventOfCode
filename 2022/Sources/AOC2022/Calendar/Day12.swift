import AOCKit
import Collections

struct Day12: Solution {
    
    private struct Point: Hashable {
        let x: Int
        let y: Int
        let distance: Int
    }
    
    private let elevations: [Character: Int] = .init(uniqueKeysWithValues: Array("abcdefghijklmnopqrstuvwxyz").enumerated().map { ($1, $0) })
    
    func question1() -> Any {
        solve(for: ["S"])
    }
    
    func question2() -> Any {
        solve(for: ["S", "a"])
    }
    
    private func solve(for startingPoints: Set<Character>) -> Int {
        var startPoints = [Point]()
        var end: Point?
        let map: [[Character]] = lines(for: "day12", in: .module).enumerated().map { y, line in
            line.enumerated().map { x, character in
                if startingPoints.contains(character) {
                    startPoints.append(.init(x: x, y: y, distance: 0))
                    return "a"
                } else if character == "E" {
                    end = .init(x: x, y: y, distance: 0)
                    return "z"
                } else {
                    return character
                }
            }
        }
        
        return startPoints
            .map { bfs(start: $0, end: end!, map: map) }
            .filter { $0 > 1 }
            .min()!
    }
    
    private func bfs(start: Point, end: Point, map: [[Character]]) -> Int {
        var points = [start]
        var mins = Array(repeating: Array(repeating: Int.max, count: map[0].count), count: map.count)
        
        while !points.isEmpty {
            let current = points.removeFirst()
            
            if current.x == end.x && current.y == end.y {
                return current.distance
            }
            
            let nextPoints: [(x: Int, y: Int)] = [
                (x: current.x - 1, y: current.y), // left
                (x: current.x + 1, y: current.y), // right
                (x: current.x, y: current.y - 1), // up
                (x: current.x, y: current.y + 1) // down
            ]

            nextPoints.forEach { x, y in
                guard x >= 0 && x < map[0].count && y >= 0 && y < map.count else { return }
                
                let currentElevation = elevations[map[current.y][current.x]]!
                let nextElevation = elevations[map[y][x]]!
                guard nextElevation - currentElevation <= 1 else { return }
                
                let point = Point(x: x, y: y, distance: current.distance + 1)
                
                let min = mins[y][x]
                if point.distance < min {
                    points.append(point)
                    mins[y][x] = point.distance
                }
            }
        }
        
        return -1
    }
}
