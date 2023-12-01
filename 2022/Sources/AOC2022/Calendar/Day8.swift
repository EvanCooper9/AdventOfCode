import AOCKit

struct Day8: Solution {

    private let trees: [[Int]] = {
        lines(for: "day8", in: .module).compactMap { line in
            line.compactMap { Int(String($0)) }
        }
    }()
    
    func question1() -> Any {
        let perimiter = (trees.count + trees[0].count) * 2 - 4
        var interior = 0
                
        for i in 1..<(trees.count - 1) {
            for j in 1..<(trees[i].count - 1) {
                let tree = trees[i][j]
                
                let lefts = trees[i][0..<j]
                let rights = trees[i][(j + 1)...]
                let ups = (0..<i).map { trees[$0][j] }
                let downs = ((i + 1)..<trees.count).map { trees[$0][j] }
                
                let visible = [lefts.max(), rights.max(), ups.max(), downs.max()]
                    .compactMap { $0 }
                    .contains(where: { $0 < tree })
                
                guard visible else { continue }
                interior += 1
            }
        }
        
        return perimiter + interior
    }
    
    func question2() -> Any {
        var maxScore = 0
        
        for i in 0..<trees.count {
            for j in 0..<trees[i].count {
                let tree = trees[i][j]
                
                let lefts = Array(trees[i][0..<j].reversed())
                let rights = Array(trees[i][(j + 1)...])
                let ups = Array((0..<i).map { trees[$0][j] }.reversed())
                let downs = Array(((i + 1)..<trees.count).map { trees[$0][j] })
                
                let score = [lefts, rights, ups, downs]
                    .map { $0.firstIndex(where: { $0 >= tree }) ?? ($0.count - 1) }
                    .reduce(into: 1) { $0 *= ($1 + 1) }
                
                maxScore = max(maxScore, score)
            }
        }
        
        return maxScore
    }
}
