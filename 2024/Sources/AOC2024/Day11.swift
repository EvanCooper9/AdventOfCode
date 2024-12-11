import AOCKit
import Algorithms
import Foundation

final class Day11: Solution {
    
    private var stones = [Int]()
    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        stones = input[0].split(separator: " ").compactMap { $0.toInt() }
    }
    
    override func question1() -> Any {
        blink(times: 25, stones: stones)
    }
    
    override func question2() -> Any {
        blink(times: 75, stones: stones)
    }
    
    private var cache = [CacheKey: Int]()
    struct CacheKey: Hashable {
        let stone: Int
        let times: Int
    }
    
    private func blink(times: Int, stones: [Int]) -> Int {
        stones.reduce(0) { previous, stone in
            let key = CacheKey(stone: stone, times: times)
            if let cached = cache[key] {
                return previous + cached
            }
            
            let stones = blink(stone: stone)
            guard times > 1 else { return previous + stones.count }
            
            let blinks = blink(times: times - 1, stones: stones)
            cache[key] = blinks
            return previous + blinks
        }
    }
    
    private func blink(stone: Int) -> [Int] {
        var stoneLength: Int { log10(stone) + 1 }
        if stone == 0 {
            return [1]
        } else if stoneLength.isMultiple(of: 2) {
            let length = stoneLength / 2
            let leading = stone / pow(10, length)
            let trailing = stone - (leading * pow(10, length))
            return [leading, trailing]
        } else {
            return [stone * 2024]
        }
    }
}
