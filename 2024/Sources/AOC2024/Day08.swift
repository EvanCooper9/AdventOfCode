import AOCKit
import Algorithms

final class Day08: Solution {
    override func question1() -> Any {
        solve { leading, trailing, distance in
            let currentXLeading = leading.x - distance.x
            let currentYLeading = leading.y + (leading.y < trailing.y ? -distance.y : distance.y)
            let currentXTrailing = trailing.x + distance.x
            let currentYTrailing = trailing.y + (leading.y < trailing.y ? distance.y : -distance.y)

            return [
                .init(x: currentXLeading, y: currentYLeading),
                .init(x: currentXTrailing, y: currentYTrailing)
            ]
        }
    }
    
    override func question2() -> Any {
        solve { leading, trailing, distance in
            var currentAntinodes = [Point]()
            var currentXLeading = leading.x
            var currentYLeading = leading.y
            var currentXTrailing = trailing.x
            var currentYTrailing = trailing.y
            while input.contains(x: currentXLeading, y: currentYLeading) || input.contains(x: currentXTrailing, y: currentYTrailing) {
                currentAntinodes.append(.init(x: currentXLeading, y: currentYLeading))
                currentAntinodes.append(.init(x: currentXTrailing, y: currentYTrailing))
                currentXLeading -= distance.x
                currentYLeading += leading.y < trailing.y ? -distance.y : distance.y
                currentXTrailing += distance.x
                currentYTrailing += leading.y < trailing.y ? distance.y : -distance.y
            }
            return currentAntinodes
        }
    }

    private typealias AntinodeClosure = (_ leading: Point, _ trailing: Point, _ distance: Point) -> [Point]
    private func solve(_ createAntinodes: AntinodeClosure) -> Int {
        var antennas = [Character: Set<Point>]()
        for y in 0 ..< input.count {
            for x in 0 ..< input[y].count {
                let character = input[y][x]
                guard character != "." else { continue }
                antennas[character, default: Set<Point>()].insert(Point(x: x, y: y))
            }
        }

        var antinodes = Set<Point>()
        antennas.forEach { character, points in
            points.uniquePermutations(ofCount: 2)
                .map { ($0[0], $0[1]) }
                .forEach { first, second in
                    let distance = Point(x: abs(second.x - first.x), y: abs(second.y - first.y))
                    let leading = first.x < second.x ? first : second
                    let trailing = leading == first ? second : first

                    for antinode in createAntinodes(leading, trailing, distance) {
                        guard input.contains(point: antinode) else { continue }
                        antinodes.insert(antinode)
                    }
                }
        }
        return antinodes.count
    }
}
