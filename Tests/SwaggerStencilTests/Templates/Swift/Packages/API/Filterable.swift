import Foundation

public protocol Filterable {
    func filter(request: URLRequest) -> URLRequest
}
