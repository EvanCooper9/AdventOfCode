import AOCKit
import Algorithms
import Foundation

final class Day18: Solution {
    
    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        bytes = input.map { line in
            let nums = line.matches(of: #/\d+/#).compactMap(\.result.int)
            return Point(x: nums[0], y: nums[1])
        }
    }
    
    override func question1() -> Any {
        run(bytes: Set(bytes[...1024]))
    }
    
    override func question2() -> Any {
        let result = binarySearch(start: 1025, end: input.count - 1) { middle in
            run(bytes: Set(bytes[...middle])) == Int.max
        }
        return input[result]
    }
    
    private var bytes = [Point]()
    
    private func run(bytes: Set<Point>) -> Int {
        let memorySpaceSize = 70
        
        var distances = Array(repeating: Array(repeating: Int.max, count: memorySpaceSize + 1), count: memorySpaceSize + 1)
        distances[0][0] = 0
        
        var queue = [Point(x: 0, y: 0)]
        while !queue.isEmpty {
            let currentPoint = queue.removeFirst()
            let currentDistance = distances[currentPoint.y][currentPoint.x]
            let movements = [currentPoint.up, currentPoint.down, currentPoint.left, currentPoint.right]
            for point in movements {
                guard distances.contains(point: point) &&
                      !bytes.contains(point) &&
                      currentDistance + 1 < distances[point.y][point.x]
                else { continue }
                
                distances[point.y][point.x] = currentDistance + 1
                queue.append(point)
            }
        }
        
        return distances[memorySpaceSize][memorySpaceSize]
    }
}
