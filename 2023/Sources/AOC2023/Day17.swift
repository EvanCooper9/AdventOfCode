import Algorithms
import AOCKit

final class Day17: Solution {

    func question1() -> Any {
        let map = input
            .filter { !$0.isEmpty }
            .map { $0.characters.map { Int(String($0))! } }

        var loss = Array(repeating: Array(repeating: Int.max, count: map[0].count), count: map.count)
        loss[0][0] = 0
        loss[0][1] = map[0][1]
        loss[1][0] = map[1][0]

        var queue = [
            (Point(x: 1, y: 0), Direction.right, 1),
            (Point(x: 0, y: 1), Direction.down, 1)
        ]
        while !queue.isEmpty {
            let (current, currentDirection, currentStepsInDirection) = queue.removeFirst()

            var possibleDirections = Direction.allCases
            possibleDirections.removeAll(where: { $0 == currentDirection.opposite }) // can't turn 180 degrees

            for direction in possibleDirections {
                guard direction != currentDirection || currentStepsInDirection < 3 else { continue }
                let nextPoint: Point = {
                    switch direction {
                    case .left: return Point(x: current.x - 1, y: current.y)
                    case .right: return Point(x: current.x + 1, y: current.y)
                    case .up: return Point(x: current.x, y: current.y - 1)
                    case .down: return Point(x: current.x, y: current.y + 1)
                    }
                }()
                guard map.contains(x: nextPoint.x, y: nextPoint.y) else { continue }

                let possibleLoss = loss[current.y][current.x] + map[nextPoint.y][nextPoint.x]
                guard possibleLoss < loss[nextPoint.y][nextPoint.x] else { continue }

                loss[nextPoint.y][nextPoint.x] = possibleLoss
                let currentStepsInDirection = currentDirection == direction ? currentStepsInDirection + 1 : 0
                queue.append((nextPoint, direction, currentStepsInDirection))
            }
        }

//        func move(to current: Point, in currentDirection: Direction, currentStepsInDirection: Int) {
//            var possibleDirections = Direction.allCases
//            possibleDirections.removeAll(where: { $0 == currentDirection.opposite }) // can't turn 180 degrees
//
//            for direction in possibleDirections {
//                guard direction != currentDirection || currentStepsInDirection < 3 else { continue }
//                let nextPoint: Point = {
//                    switch direction {
//                    case .right: return Point(x: current.x + 1, y: current.y)
//                    case .down: return Point(x: current.x, y: current.y + 1)
//                    case .left: return Point(x: current.x - 1, y: current.y)
////                    case .right: return Point(x: current.x + 1, y: current.y)
//                    case .up: return Point(x: current.x, y: current.y - 1)
////                    case .down: return Point(x: current.x, y: current.y + 1)
//                    }
//                }()
//                guard map.contains(x: nextPoint.x, y: nextPoint.y) else { continue }
//
//                let possibleLoss = loss[current.y][current.x] + map[nextPoint.y][nextPoint.x]
//                guard possibleLoss < loss[nextPoint.y][nextPoint.x] else { continue }
//
//                loss[nextPoint.y][nextPoint.x] = possibleLoss
//                let currentStepsInDirection = currentDirection == direction ? currentStepsInDirection + 1 : 0
//
//                move(to: nextPoint, in: direction, currentStepsInDirection: currentStepsInDirection)
//            }
//        }
//
//        move(to: Point(x: 0, y: 0), in: .right, currentStepsInDirection: 0)

        loss.forEach {
            print($0)
        }

        return loss[loss.count - 1][loss[0].count - 1]
    }

    func question2() -> Any {
        0
    }

    func moveTo(x: Int, y: Int, accumulatedHeatLoss: Int) {
        
    }

    private struct Point {
        let x: Int
        let y: Int
    }

    private enum Direction: CaseIterable {
        case left, right, up, down

        var opposite: Direction {
            switch self {
            case .left: return .up
            case .right: return .left
            case .up: return .down
            case .down: return .up
            }
        }
    }
}
