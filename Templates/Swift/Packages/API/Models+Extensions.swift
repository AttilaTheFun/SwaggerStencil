import Models

extension Models.Error: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}
