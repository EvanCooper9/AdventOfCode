import Foundation

public struct Point: Hashable {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public extension Point {
    var left: Point { Point(x: x - 1, y: y) }
    var right: Point { Point(x: x + 1, y: y) }
    var up: Point { Point(x: x, y: y - 1) }
    var down: Point { Point(x: x, y: y + 1) }
}

public extension Point {
    func next(direction: Direction) -> Point {
        switch direction {
        case .up: return up
        case .down: return down
        case .left: return left
        case .right: return right
        }
    }
}
