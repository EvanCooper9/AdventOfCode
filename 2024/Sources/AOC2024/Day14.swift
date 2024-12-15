import AOCKit
import Algorithms
import Foundation

final class Day14: Solution {

    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        robots = input.map { line in
            let numbers = line.matches(of: #/\d+|-\d+/#).compactMap { line[$0.range].toInt()  }
            let position = Point(x: numbers[0], y: numbers[1])
            let direction = Point(x: numbers[2], y: numbers[3])
            return Robot(position: position, direction: direction)
        }
    }

    override func question1() -> Any {
        let hX = 101
        let hY = 103

        var quads = [0, 0, 0, 0]
        robots.forEach { robot in
            let posX = (robot.position.x + robot.direction.x * 100) % hX
            let posY = (robot.position.y + robot.direction.y * 100) % hY
            let x = (posX < 0 ? hX : 0) + posX
            let y = (posY < 0 ? hY : 0) + posY

            if x < hX / 2 && y < hY / 2 {
                quads[0] += 1 // top left
            } else if x > hX / 2 && y < hY / 2 {
                quads[1] += 1 // top right
            } else if x < hX / 2 && y > hY / 2 {
                quads[2] += 1 // bottom left
            } else if x > hX / 2 && y > hY / 2 {
                quads[3] += 1 // bottom right
            }
        }

        return quads.product
    }
    
    override func question2() -> Any {
        let hX = 101
        let hY = 103
        var positions = robots.map(\.position)
        let directions = robots.map(\.direction)
        let loops = 10000

        var max = 0
        var maxIndex = 0
        for i in 1 ... loops {
            var quads = [0, 0, 0, 0]
            positions = zip(positions, directions).map { position, direction in
                let posX = (position.x + direction.x) % hX
                let posY = (position.y + direction.y) % hY
                let x = (posX < 0 ? hX : 0) + posX
                let y = (posY < 0 ? hY : 0) + posY

                if x < hX / 2 && y < hY / 2 {
                    quads[0] += 1 // top left
                } else if x > hX / 2 && y < hY / 2 {
                    quads[1] += 1 // top right
                } else if x < hX / 2 && y > hY / 2 {
                    quads[2] += 1 // bottom left
                } else if x > hX / 2 && y > hY / 2 {
                    quads[3] += 1 // bottom right
                }

                return Point(x: x, y: y)
            }

            for quad in quads {
                guard quad > max else { continue }
                max = quad
                maxIndex = i
            }
        }

        return maxIndex
    }

    private var robots = [Robot]()
    private struct Robot {
        let position: Point
        let direction: Point
    }
}
