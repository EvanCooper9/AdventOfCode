import AOCKit
import Algorithms
import Foundation

final class Day10: Solution {
    
    private var trailMap = [[Int]]()

    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        trailMap = input.map { line in
            line.compactMap(\.wholeNumberValue)
        }
    }
    
    override func question1() -> Any {
        mapScore { trailHead in
            let trailEnds = distinctTrails(x: trailHead.x, y: trailHead.y)
                .compactMap(\.last)
                .uniqued()
            return Set(trailEnds).count
        }
    }
    
    override func question2() -> Any {
        mapScore { trailHead in
            distinctTrails(x: trailHead.x, y: trailHead.y).count
        }
    }
    
    private typealias Trail = [Point]
    
    private func mapScore(calculateTrailHeadScore: (_ trailHead: Point) -> Int) -> Int {
        var score = 0
        for y in 0 ..< trailMap.count {
            for x in 0 ..< trailMap[y].count {
                guard trailMap[y][x] == 0 else { continue }
                score += calculateTrailHeadScore(Point(x: x, y: y))
            }
        }
        return score
    }
    
    private func distinctTrails(x: Int, y: Int, expectedHeight: Int = 0, currentTrail: Trail = []) -> Set<Trail> {
        guard trailMap.contains(x: x, y: y),
              trailMap[y][x] == expectedHeight
        else { return [] }
        
        var trail = currentTrail
        trail.append(Point(x: x, y: y))
        
        if trailMap[y][x] == 9 {
            return [trail]
        }
        
        let left = distinctTrails(x: x - 1, y: y, expectedHeight: expectedHeight + 1, currentTrail: trail)
        let right = distinctTrails(x: x + 1, y: y, expectedHeight: expectedHeight + 1, currentTrail: trail)
        let up = distinctTrails(x: x, y: y - 1, expectedHeight: expectedHeight + 1, currentTrail: trail)
        let down = distinctTrails(x: x, y: y + 1, expectedHeight: expectedHeight + 1, currentTrail: trail)
        
        let joined = [left, right, up, down]
            .map(Array.init)
            .joined()
        
        return Set(joined)
    }
}
