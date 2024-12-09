import AOCKit
import Algorithms
import Foundation

final class Day09: Solution {

    private var diskMap = [Int]()

    override init(bundle: Bundle) {
        super.init(bundle: bundle)
        diskMap = input[0].compactMap(\.wholeNumberValue)
    }

    override func question1() -> Any {
        var checksum = 0
        var checksumIndex = 0
        var currentTrailingFileIndex = diskMap.count - 1
        var currentTrailingFileBlock = 0
        for (index, size) in diskMap.enumerated() {
            let fileID = index / 2
            let handleFile = index < currentTrailingFileIndex && index.isMultiple(of: 2)
            let handleFreeSpace = index <= currentTrailingFileIndex
            guard handleFile || handleFreeSpace else {
                checksumIndex += size
                continue
            }
            for _ in 0 ..< size {
                defer { checksumIndex += 1 }
                if handleFile {
                    checksum += checksumIndex * fileID
                } else if handleFreeSpace {
                    guard index <= currentTrailingFileIndex else { continue }

                    let trailingFileID = currentTrailingFileIndex / 2
                    let trailingFileSize = diskMap[currentTrailingFileIndex]
                    checksum += checksumIndex * trailingFileID

                    currentTrailingFileBlock += 1
                    if currentTrailingFileBlock >= trailingFileSize {
                        currentTrailingFileIndex -= 2
                        currentTrailingFileBlock = 0
                    }
                }
            }
        }

        return checksum
    }
    
    override func question2() -> Any {
        var checksum = 0
        var checksumIndex = 0
        var handledFileIndicies = Set<Int>()
        for (index, size) in diskMap.enumerated() {
            defer { handledFileIndicies.insert(index) }
            if !handledFileIndicies.contains(index) && index.isMultiple(of: 2) {
                let fileID = index / 2
                for _ in 0 ..< size {
                    checksum += checksumIndex * fileID
                    checksumIndex += 1
                }
            } else {
                var remainingSpace = size
                while remainingSpace > 0 {
                    let movableTrailingFileIndex = stride(from: diskMap.count - 1, to: index, by: -2).first { index in
                        guard !handledFileIndicies.contains(index) else { return false }
                        let blockSize = diskMap[index]
                        return blockSize <= remainingSpace
                    }

                    if let movableTrailingFileIndex {
                        let movableTrailingFileID = movableTrailingFileIndex / 2
                        let movableTrailingFileSize = diskMap[movableTrailingFileIndex]
                        for _ in 0 ..< movableTrailingFileSize {
                            checksum += checksumIndex * movableTrailingFileID
                            checksumIndex += 1
                        }

                        handledFileIndicies.insert(movableTrailingFileIndex)
                        remainingSpace -= movableTrailingFileSize
                    } else {
                        checksumIndex += remainingSpace
                        remainingSpace = 0
                    }
                }
            }
        }

        return checksum
    }
}
