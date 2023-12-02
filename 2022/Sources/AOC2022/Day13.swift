import Algorithms
import AOCKit
import Foundation

struct Day13: Solution {
    
    public enum Item: CustomStringConvertible, Decodable, Equatable {
        case int(Int)
        case array([Item])

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Int.self) {
                self = .int(x)
                return
            }
            if let x = try? container.decode([Item].self) {
                self = .array(x)
                return
            }
            throw DecodingError.typeMismatch(Item.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Item"))
        }
        
        public var description: String {
            switch self {
            case .int(let int):
                return int.description
            case .array(let array):
                return array.description
            }
        }
    }
    
    private let pairs: [([Item], [Item])] = {
        lines(for: "day13", in: .module)
            .chunks(ofCount: 3)
            .map { chunk in
                let first = chunk[chunk.startIndex]
                let second = chunk[chunk.startIndex + 1]
                let result = [first, second].compactMap { line -> [Item]? in
                    guard let data = line.data(using: .utf8) else { return nil }
                    return try? JSONDecoder().decode([Item].self, from: data)
                }
                
                return (result[0], result[1])
            }
    }()
    
    func question1() -> Any {
        pairs
            .enumerated()
            .filter { compare(left: $1.0, right: $1.1) == 1 }
            .map { $0.offset + 1 }
            .reduce(0, +)
    }
    
    func question2() -> Any {
        var packets = pairs.flatMap { [$0.0, $0.1] }
        
        let divider1: [Item] = [.array([.int(2)])]
        let divider2: [Item] = [.array([.int(6)])]
        packets.append(divider1)
        packets.append(divider2)
        
        return packets
            .sorted { compare(left: $0, right: $1) == 1 }
            .enumerated()
            .compactMap { offset, packet -> Int? in
                guard packet == divider1 || packet == divider2 else { return nil }
                return offset + 1
            }
            .reduce(1, *)
    }
    
    private func compare(left: [Item], right: [Item]) -> Int {
        for i in 0..<Swift.max(left.count, right.count) {
            if i == left.count {
                return 1
            } else if i == right.count {
                return 0
            }
            
            var ordered = -1
            switch (left[i], right[i]) {
            case let (.int(l), .int(r)):
                if l < r {
                    ordered = 1
                } else if l > r {
                    ordered = 0
                } else {
                    ordered = -1
                    continue
                }
            case let (.array(l), .array(r)):
                ordered = compare(left: l, right: r)
            case let (.array(l), .int):
                ordered = compare(left: l, right: [right[i]])
            case let (.int, .array(r)):
                ordered = compare(left: [left[i]], right: r)
            }
            
            if ordered != -1 {
                return ordered
            }
        }
        
        return -1
    }
}
