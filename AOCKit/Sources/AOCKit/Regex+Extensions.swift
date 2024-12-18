@available(macOS 13.0, *)
public extension Regex.Match where Output == Substring {
    var result: Substring {
        self.base[range]
    }
}

