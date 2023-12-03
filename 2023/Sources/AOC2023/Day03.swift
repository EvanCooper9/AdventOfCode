import Algorithms
import AOCKit

final class Day03: Solution {

    func question1() -> Any {
        parts
            .filter { part in
                symbols.contains { part.isAdjacent(to: $0.point) }
            }
            .removingDuplicates()
            .map(\.number)
            .reduce(0, +)
    }
    
    func question2() -> Any {
        symbols
            .map { symbol in
                guard symbol.isGear else { return 0 }
                let adjacentParts = parts.filter { $0.isAdjacent(to: symbol.point) }
                if adjacentParts.count == 2 {
                    return adjacentParts
                        .map(\.number)
                        .reduce(1, *)
                }
                return 0
            }
            .reduce(0, +)
    }

    init() {
        input.enumerated().forEach { y, line in
            var currentPart: Part?
            func saveCurrentPart() {
                guard let part = currentPart else { return }
                parts.append(part)
                currentPart = nil
            }
            defer { saveCurrentPart() }

            line.enumerated().forEach { x, character in
                let currentPoint = Point(x: x, y: y)
                if let number = character.wholeNumberValue {
                    currentPart = Part(
                        number: (currentPart?.number ?? 0) * 10 + number,
                        start: currentPart?.start ?? currentPoint,
                        end: currentPoint
                    )
                } else {
                    saveCurrentPart()
                    if character != "." {
                        let symbol = Symbol(point: currentPoint, isGear: character == "*")
                        symbols.append(symbol)
                    }
                }
            }
        }
    }

    private struct Symbol {
        let point: Point
        let isGear: Bool
    }

    private struct Part: Hashable {
        let number: Int
        let start: Point
        let end: Point

        func isAdjacent(to point: Point) -> Bool {
            let xRange = (start.x - 1)...(end.x + 1)
            let yRange = (start.y - 1)...(end.y + 1)
            return xRange.contains(point.x) && yRange.contains(point.y)
        }
    }

    private struct Point: Hashable {
        let x: Int
        let y: Int
    }

    private var symbols = [Symbol]()
    private var parts = [Part]()
}
