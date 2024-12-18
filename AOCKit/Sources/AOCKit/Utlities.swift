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
