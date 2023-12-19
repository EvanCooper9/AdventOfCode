import Algorithms
import AOCKit

final class Day15: Solution {

    func question1() -> Any {
        input.first!
            .split(separator: ",")
            .map(hashValue(for:))
            .sum
    }

    func question2() -> Any {
        
        struct Lens {
            let label: String
            var focalLength: Int
        }

        var boxes = Array(repeating: [Lens](), count: 256)

        input.first!
            .split(separator: ",")
            .map(String.init)
            .forEach { step in
                let label = String(step.prefix(while: { !["-", "="].contains($0) }))
                let boxIndex = hashValue(for: label)

                switch step[label.count] {
                case "-":
                    boxes[boxIndex].removeAll(where: { $0.label  == label })
                case "=":
                    let focalLength = Int(String(step.last!))!
                    if let lensIndex = boxes[boxIndex].firstIndex(where: { $0.label == label }) {
                        boxes[boxIndex][lensIndex].focalLength = focalLength
                    } else {
                        boxes[boxIndex].append(Lens(label: label, focalLength: focalLength))
                    }
                default:
                    break
                }
            }

        return boxes
            .enumerated()
            .map { boxNumber, lenses in
                lenses.enumerated()
                    .map { lensIndex, lens in (boxNumber + 1) * (lensIndex + 1) * lens.focalLength }
                    .sum
            }
            .sum
    }

    private func hashValue<S: StringProtocol>(for string: S) -> Int {
        string.characters
            .compactMap(\.asciiValue)
            .map(Int.init)
            .reduce(0) { sum, asciiValue in
                ((sum + asciiValue) * 17) % 256
            }
    }
}
