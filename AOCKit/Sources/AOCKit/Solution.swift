import Foundation

public protocol Solution {
    var input: [String] { get }
    func question1() -> Any
    func question2() -> Any
}

public extension Solution {
    var input: [String] { [] }
}

public func lines(for filename: String, in bundle: Bundle) -> [String] {
    guard let file = bundle.path(forResource: filename, ofType: "txt") else { return [] }
    guard let input = try? String(contentsOfFile: file) else { return [] }
    return input.components(separatedBy: .newlines).dropLast()
}
