import AOCKit
import Foundation

struct Day3: Solution {
    
    private let rudsacks: [String] = { lines(for: "day3", in: .module) }()
    
    func question1() -> Any {
        rudsacks.reduce(into: 0) { partialResult, rudsack in
            let rightSet = Set(rudsack.prefix(rudsack.count / 2).map { $0 })
            var alreadyAdded = Set<Character>()
            for character in rudsack.suffix(rudsack.count / 2) {
                if rightSet.contains(character) && !alreadyAdded.contains(character) {
                    partialResult += character.priority ?? 0
                    alreadyAdded.insert(character)
                    continue
                }
            }
        }
    }
    
    func question2() -> Any {
        var sum = 0
        for i in stride(from: 0, to: rudsacks.count - 3, by: 3) {
            let first = rudsacks[i].bitmask
            let second = rudsacks[i + 1].bitmask
            let third = rudsacks[i + 2].bitmask
            
            let result = log2(CGFloat(first & second & third))
            sum += Int(result)
        }
        return sum
    }
}

extension Character {
    // 'a' through 'z' == 1 through 26
    // 'A' through 'Z' == 27 through 52
    var priority: Int? {
        guard let asciiValue else { return nil }
        let v = Int(asciiValue)
        if v < 97 { // uppercase
            return v - 65 + 26 + 1
        }
        return v - 97 + 1 // lowercase
    }
    
    var bitmask: Int? {
        guard let priority else { return nil }
        return Int(pow(2.0, Double(priority)))
    }
}

extension String {
    var bitmask: Int {
        reduce(0) { result, character in
            guard let bitmask = character.bitmask else { return result }
            return result | bitmask
        }
    }
}
