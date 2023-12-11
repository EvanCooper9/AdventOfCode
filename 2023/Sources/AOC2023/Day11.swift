import Algorithms
import AOCKit

final class Day11: Solution {

    func question1() -> Any {
        solve(expandFactor: 2)
    }

    func question2() -> Any {
        solve(expandFactor: 1_000_000)
    }

    init() {
        image = input.map { $0.compactMap(Pixel.init) }

        rowsWithoutGalaxies = image.enumerated()
            .filter { !$0.element.contains(.galaxy) }
            .map(\.offset)

        for column in 0..<image[0].count {
            let doesNotContainGalaxy = (0..<image.count).allSatisfy { image[$0][column] == .empty }
            if doesNotContainGalaxy {
                columnsWithoutGalaxies.append(column)
            }
        }
    }

    enum Pixel: Character {
        case galaxy = "#"
        case empty = "."
    }

    private struct Point: Equatable {
        let x: Int
        let y: Int
    }

    private func solve(expandFactor: Int) -> Int {
        var galaxyPoints = [Point]()
        for y in image.indices {
            for (x, pixel) in image[y].enumerated() {
                if pixel == .galaxy {
                    galaxyPoints.append(Point(x: x, y: y))
                }
            }
        }

        galaxyPoints = galaxyPoints.map { point in
            let rowOffset = rowsWithoutGalaxies.filter({ point.y > $0 }).count * (expandFactor - 1)
            let columnOffset = columnsWithoutGalaxies.filter({ point.x > $0 }).count * (expandFactor - 1)
            return Point(x: point.x + columnOffset, y: point.y + rowOffset)
        }

        return galaxyPoints
            .enumerated()
            .compactMap { startIndex, start in
                galaxyPoints
                    .filter { $0 != start }
                    .enumerated()
                    .map { endIndex, end in
                        let xPath = max(start.x, end.x) - min(start.x, end.x)
                        let yPath = max(start.y, end.y) - min(start.y, end.y)
                        return xPath + yPath
                    }
                    .reduce(0, +)
            }
            .reduce(0, +) / 2
    }

    private var image = [[Pixel]]()
    private var rowsWithoutGalaxies = [Int]()
    private var columnsWithoutGalaxies = [Int]()
}
