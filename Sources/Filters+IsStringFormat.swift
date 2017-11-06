import Stencil
import SwaggerParser

extension Filters {
    static func isStringFormat(value: Any?, arguments: [Any?]) throws -> Any? {
        guard let stringItem = value as? StringItem else {
            throw TemplateSyntaxError("Expected StringItem")
        }

        guard let stringFormat = stringItem.format else {
            return ""
        }

        guard let stringOptional = arguments.first, let string = stringOptional as? String else {
            throw TemplateSyntaxError("Expected StringFormat")
        }

        let comparisonStringFormat = StringFormat(rawValue: string)
        return stringFormat == comparisonStringFormat ? "true" : ""
    }
}
