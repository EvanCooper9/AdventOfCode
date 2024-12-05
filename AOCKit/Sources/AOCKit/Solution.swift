import Foundation

open class Solution {

    public let input: [String]

    public init(bundle: Bundle) {
        let type = String(describing: Self.self)
        input = lines(for: String(type), in: bundle)
    }

    open func question1() -> Any {
        1
    }

    open func question2() -> Any {
        2
    }
}

public func lines(for filename: String, in bundle: Bundle) -> [String] {
    guard let file = bundle.path(forResource: filename, ofType: "txt") else { return [] }
    guard let input = try? String(contentsOfFile: file) else { return [] }
    return input.components(separatedBy: .newlines).dropLast()
}
