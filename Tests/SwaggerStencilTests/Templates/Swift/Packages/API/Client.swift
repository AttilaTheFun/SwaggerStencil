import Foundation
import PromiseKit

public enum ClientError: Error {
    case noResponse
    case noData
    case badString
}

public final class Client {
    private let baseURL: URL
    private let session: URLSession
    private let delegate = ClientDelegate()
    private var filters = [Filterable]()

    required public init(baseURL: URL, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: nil)
    }

    public func add(filter: Filterable) {
        self.filters.append(filter)
    }

    func makeRequest(method: String, path: String, pathParameters: [String : String],
                     queryParameters: [String : String], body: Data?, headers: [String : String])
        -> Promise<(HTTPURLResponse, Data?)>
    {
        let populatedPath = path.populatePath(keyValuePairs: pathParameters)
        let queryParameterString = "?" + queryParameters.stringFromQueryParameters()
        var urlString = self.baseURL.absoluteString + populatedPath
        if queryParameters.count > 0 {
            urlString += queryParameterString
        }

        guard let url = URL(string: urlString) else {
            return Promise(error: ClientError.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        self.filters.forEach { request = $0.filter(request: request) }

        return Promise { fulfill, reject in
            let task = self.session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    return reject(error)
                }

                guard let response = response as? HTTPURLResponse else {
                    return reject(ClientError.noResponse)
                }

                fulfill((response, data))
            }

            task.resume()
        }
    }
}

final class ClientDelegate: NSObject {}

extension ClientDelegate: URLSessionTaskDelegate {}

