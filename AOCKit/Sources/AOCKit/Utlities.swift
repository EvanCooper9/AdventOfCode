// GCD of two numbers:
public func gcd(_ a: Int, _ b: Int) -> Int {
    var (a, b) = (a, b)
    while b != 0 {
        (a, b) = (b, a % b)
    }
    return abs(a)
}

// GCD of a vector of numbers:
public func gcd(_ vector: [Int]) -> Int {
    vector.reduce(0, gcd)
}

// LCM of two numbers:
public func lcm(a: Int, b: Int) -> Int {
    (a / gcd(a, b)) * b
}

// LCM of a vector of numbers:
public func lcm(_ vector : [Int]) -> Int {
    vector.reduce(1, lcm)
}
