import Foundation

/// GCD of two numbers:
public func gcd(_ a: Int, _ b: Int) -> Int {
    var (a, b) = (a, b)
    while b != 0 {
        (a, b) = (b, a % b)
    }
    return abs(a)
}

/// GCD of a vector of numbers:
public func gcd(_ vector: [Int]) -> Int {
    vector.reduce(0, gcd)
}

/// LCM of two numbers:
public func lcm(a: Int, b: Int) -> Int {
    (a / gcd(a, b)) * b
}

/// LCM of a vector of numbers:
public func lcm(_ vector : [Int]) -> Int {
    vector.reduce(1, lcm)
}

public func pow(_ x: Int, _ y: Int) -> Int {
    Int(pow(Double(x), Double(y)))
}

public func countNumbers(n: Int) -> Int {
    guard n > 0 else { return 0 }
    return countNumbers(n: n / 10) + 1
}

public func log10(_ value: Int) -> Int {
    return Int(log(Double(value)) / log(10.0))
}

public func binarySearch(start: Int, end: Int, shouldSearchDown: (Int) -> Bool) -> Int {
    var start = start
    var end = end
    while start < end {
        let middle = start + (end - start) / 2
        if shouldSearchDown(middle) {
            end = middle - 1
        } else {
            start = middle + 1
        }
    }
    
    return start
}

public func distances<Element>(
    from start: Point,
    in grid: [[Element]],
    validate: (Element) -> Bool,
    cost: (_ currentDistance: Int, _ current: Point, _ next: Point) -> Int
) -> [[Int]] {
    var distances = Array(repeating: Array(repeating: Int.max, count: grid[0].count), count: grid.count)
    distances[start.y][start.x] = 0
    var queue = [start]
    while !queue.isEmpty {
        let current = queue.removeFirst()
        let currentDistance = distances[current.y][current.x]
        for next in [current.up, current.down, current.left, current.right] {
            let cost = cost(currentDistance, current, next)
            guard distances.contains(point: next),
                  validate(grid[next.y][next.x]),
                  cost <= distances[next.y][next.x]
            else { continue }
            
            distances[next.y][next.x] = cost
            queue.append(next)
        }
    }
    
    return distances
}
