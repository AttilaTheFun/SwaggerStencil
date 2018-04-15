import Foundation
import Stencil

enum Filters {
    enum Error: Swift.Error {
        case invalidInputType
    }

    static func wrapInCurlyBraces(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return "{\(string)}"
    }

    static func alphabetizeLines(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.components(separatedBy: "\n").sorted().joined(separator: "\n")
    }

    static func removeNewlines(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.components(separatedBy: "\n").joined()
    }

    static func trimWhitespace(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.trimmingCharacters(in: .whitespaces)
    }

    static func trimTrailingComma(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        if string.hasSuffix(",") {
            return String(string.dropLast())
        } else if string.hasSuffix(", ") {
            return String(string.dropLast().dropLast())
        }

        return string
    }

    static func pathToPascal(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.pathToPascal()
    }

    static func toPascal(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toPascal()
    }

    static func toCamel(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toCamel()
    }

    static func toSnake(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toSnake()
    }

    static func toScreamingSnake(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toScreamingSnake()
    }
}
