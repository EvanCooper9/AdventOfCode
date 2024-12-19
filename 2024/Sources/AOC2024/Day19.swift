import AOCKit
import Algorithms
import Foundation

final class Day19: Solution {
    
    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        patterns = Set(input[0].split(separator: ", "))
        patternMax = patterns.map(\.count).max() ?? 0
    }
    
    override func question1() -> Any {
        input[2...]
            .filter { possibilities(design: $0) > 0 }
            .count
    }
    
    override func question2() -> Any {
        input[2...]
            .map(possibilities(design:))
            .sum
    }
    
    private var patterns = Set<Substring>()
    private var patternMax = 0
    private var possibilitiesCache = [String: Int]()
    
    private func possibilities(design: String) -> Int {
        if let cached = possibilitiesCache[design] {
            return cached
        }
        
        let result = (0 ..< min(patternMax, design.count))
            .map { i in
                let sub = design[...i]
                guard patterns.contains(sub) else { return 0 }
                return design.count == sub.count ? 1 : possibilities(design: String(design[sub.count...]))
            }
            .sum
        
        possibilitiesCache[design] = result
        return result
    }
}
