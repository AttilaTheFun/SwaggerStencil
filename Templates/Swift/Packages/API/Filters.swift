import Foundation

public protocol RequestFilter {
    func filter(request: URLRequest) -> URLRequest
}

public protocol ResponseFilter {
    func filter(response: HTTPURLResponse) -> HTTPURLResponse
}
