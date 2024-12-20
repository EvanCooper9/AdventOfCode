import AOCKit
import Algorithms

final class Day20: Solution {
    override func question1() -> Any {
        cheatCount(inRadius: 2)
    }
    
    override func question2() -> Any {
        cheatCount(inRadius: 20)
    }

    private struct Cheat: Hashable {
        let start: Point
        let end: Point
    }

    private func cheatCount(inRadius cheatRadius: Int) -> Int {
        guard let start = find("S") else { fatalError("Start not found") }
        
        let distances = distances(from: start, in: input.map(\.characters)) { character in
            character != "#"
        } cost: { currentDistance, _, _ in
            currentDistance + 1
        }

        var cheats = Set<Cheat>()
        var queue = [start]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let yRange = (current.y - cheatRadius ... current.y + cheatRadius).clamped(to: 0 ... input.count - 1)
            let xRange = (current.x - cheatRadius ... current.x + cheatRadius).clamped(to: 0 ... input[0].count - 1)

            for (y, x) in product(yRange, xRange) {
                let cheatPoint = Point(x: x, y: y)
                let dist = abs(current.x - x) + abs(current.y - y)
                guard cheatPoint != current,
                      distances[cheatPoint.y][cheatPoint.x] != Int.max,
                      dist <= cheatRadius
                else { continue }

                let diff = (distances[current.y][current.x] + dist) - distances[cheatPoint.y][cheatPoint.x]
                guard diff <= -100 else { continue }
                cheats.insert(Cheat(start: current, end: cheatPoint))
            }

            for next in [current.up, current.down, current.left, current.right] {
                guard distances.contains(point: next),
                      distances[next.y][next.x] == distances[current.y][current.x] + 1
                else { continue }
                queue.append(next)
            }
        }

        return cheats.count
    }

    private func find(_ character: Character) -> Point? {
        for (y, x) in product(input.indices, input[0].indices) {
            if input[y][x] == character {
                return Point(x: x.utf16Offset(in: input[y]), y: y)
            }
        }
        return nil
    }
}
