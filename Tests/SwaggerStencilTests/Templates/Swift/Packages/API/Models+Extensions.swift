import Models

extension Models.Error: Swift.Error {
    public var localizedDescription: String {
        return self.message
    }
}