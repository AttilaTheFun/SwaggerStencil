import Foundation

enum Filters {
    enum Error: Swift.Error {
        case invalidInputType
    }

    static func removeNewlines(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.replacingOccurrences(of: "\n", with: "")
    }

    static func pathToPascal(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.pathToPascal()
    }

    static func toPascal(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toPascal()
    }
}
