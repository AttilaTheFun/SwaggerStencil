import Foundation

extension String {
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: Returns percent-escaped string.
    public func addingPercentEncodingForURLQueryValue() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return addingPercentEncoding(withAllowedCharacters: allowed)
    }

    /// Populate the receiver with the key value pairs with the format where /{key} will result in /value
    ///
    /// - parameter parameters: Dictionary of key value pairs to replace.
    ///
    /// - returns: A new string with the formatted keys replaced with the values in the dictionary.
    public func populateTemplate(with keyValuePairs: [String : String]) -> String {
        var populated = self
        for (key, value) in keyValuePairs {
            populated = populated.replacingOccurrences(of: "{\(key)}", with: value)
        }

        return populated
    }

    /// Populates the receiver with path parameters and appends a query string.
    ///
    public func populate(baseURL: URL, pathParameters: [String: String] = [:],
                         queryParameters: [String: String] = [:]) -> URL?
    {
        let populatedPath = self.populateTemplate(with: pathParameters)
        let queryParameterString = "?" + queryParameters.stringFromQueryParameters()
        var urlString = baseURL.absoluteString + populatedPath
        if queryParameters.count > 0 {
            urlString += queryParameterString
        }

        return URL(string: urlString)
    }
}
