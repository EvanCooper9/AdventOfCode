public extension Range where Bound == Int {
    var mid: Bound {
        lowerBound + ((upperBound - lowerBound) / 2)
    }
}
