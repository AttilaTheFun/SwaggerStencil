import Foundation

extension APIError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}
