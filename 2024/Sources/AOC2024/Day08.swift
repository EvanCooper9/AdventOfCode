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
                if character != "." {
                    let point = Point(x: x, y: y)
                    antennas[character, default: Set<Point>()].insert(point)
                }
            }
        }

        var antinodes = Set<Point>()
        antennas.forEach { character, points in
            points.uniquePermutations(ofCount: 2).forEach { permutation in
                let distance = Point(x: abs(permutation[1].x - permutation[0].x), y: abs(permutation[1].y - permutation[0].y))
                let leading = permutation[0].x < permutation[1].x ? permutation[0] : permutation[1]
                let trailing = leading == permutation[0] ? permutation[1] : permutation[0]

                for antinode in createAntinodes(leading, trailing, distance) {
                    guard input.contains(point: antinode) else { continue }
                    antinodes.insert(antinode)
                }
            }
        }
        return antinodes.count
    }
}

extension Collection {
    func pairs(where isPair: (Element, Element) -> Bool) -> [(Element, Element)] {
        var pairs = [(Element, Element)]()
        forEach { element in
            forEach { other in
                if isPair(element, other) {
                    pairs.append((element, other))
                }
            }
        }
        return pairs
    }
}
