import Foundation
import PromiseKit

public enum ClientError: String {
    case noResponse = "No response from server"
    case noData = "HTTP response contained no data"
    case badString = "Failed to decode response into utf-8 string"
    case badBoolean = "Booleans must be encoded as string literals 'true' or 'false' respectively"
    case badURL = "Failed to build url for HTTP request"
}

extension ClientError: LocalizedError {
    public var errorDescription: String? {
        return self.rawValue
    }
}

public final class Client {
    private let baseURL: URL
    private let session: URLSession
    private var requestFilters = [RequestFilter]()
    private var responseFilters = [ResponseFilter]()

    required public init(baseURL: URL, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }

    public func add(filter: RequestFilter) {
        self.requestFilters.append(filter)
    }

    public func add(filter: ResponseFilter) {
        self.responseFilters.append(filter)
    }

    func makeRequest(method: String, path: String, pathParameters: [String : String],
                     queryParameters: [String : String], body: Data?, headers: [String : String])
        -> Promise<(HTTPURLResponse, Data)>
    {
        guard let url = path.populate(baseURL: self.baseURL, pathParameters: pathParameters,
                                      queryParameters: queryParameters) else
        {
            return Promise(error: ClientError.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        self.requestFilters.forEach { request = $0.filter(request: request) }

        return Promise { seal in
            let task = self.session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    return seal.reject(error)
                }

                guard let data = data else {
                    return seal.reject(ClientError.noData)
                }

                guard var response = response as? HTTPURLResponse else {
                    return seal.reject(ClientError.noResponse)
                }

                self.responseFilters.forEach { response = $0.filter(response: response) }
                seal.fulfill((response, data))
            }

            task.resume()
        }
    }
}
