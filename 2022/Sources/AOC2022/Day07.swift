import AOCKit

struct Day7: Solution {

    private class Directory {
        
        let path: String
        var fileSizes = [Int]()
        var parent: Directory?
        var directories = [Directory]()
        
        init(path: String, parent: Directory? = nil) {
            self.path = path
            self.parent = parent
        }
        
        var deepSize: Int {
            let files = fileSizes.reduce(0, +)
            let directories = directories
                .map(\.deepSize)
                .reduce(0, +)
            return files + directories
        }
    }
    
    private let system: Directory = {
        var root = Directory(path: "/")
        var current = root
        
        for line in lines(for: "day7", in: .module).dropFirst() {
            if line.starts(with: "$") { // command
                if line == "$ cd .." {
                    current = current.parent!
                } else if line.starts(with: "$ cd") {
                    let dir = line.components(separatedBy: " ")[2]
                    current = current.directories.first(where: { $0.path.hasSuffix(dir) })!
                }
            } else { // output
                let item = line.components(separatedBy: " ")
                if let size = Int(item.first ?? "") {
                    current.fileSizes.append(size)
                } else if item.first == "dir" {
                    let path = current.path == "/" ? "/\(item.last!)" : current.path + "/\(item.last!)"
                    current.directories.append(.init(path: path, parent: current))
                }
            }
        }
        return root
    }()
    
    private func traverse(_ directory: Directory, handle: (Directory) -> Void) {
        handle(directory)
        directory.directories.forEach { traverse($0, handle: handle) }
    }
    
    func question1() -> Any {
        var sum = 0
        traverse(system) { directory in
            guard directory.deepSize <= 100_000 else { return }
            sum += directory.deepSize
        }
        return sum
    }
    
    func question2() -> Any {
        let diskSize = 70_000_000
        let requiredSpace = 30_000_000
        let available = diskSize - system.deepSize
        let spaceToBeDeleted = requiredSpace - available
        var smallestToDelete = system.deepSize
        traverse(system) { directory in
            guard directory.deepSize >= spaceToBeDeleted else { return }
            smallestToDelete = min(smallestToDelete, directory.deepSize)
        }
        return smallestToDelete
    }
}
