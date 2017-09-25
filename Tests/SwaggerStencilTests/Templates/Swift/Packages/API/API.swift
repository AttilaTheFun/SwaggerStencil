import Foundation

public struct API {
    public static var client = Client(baseURL: URL(string: "{{ swagger.host }}")!)
}
