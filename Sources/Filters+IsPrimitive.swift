import SwaggerParser
import Stencil

extension Filters {
    static func isPrimitive(value: Any?) throws -> Any? {
        let schema: Schema
        if let either = value as? Either<Schema, Structure<Schema>> {
            schema = either.structure
        } else if let value = value as? Schema {
            schema = value
        } else {
            throw TemplateSyntaxError("Expected Schema")
        }

        let isPrimitive: Bool
        switch schema.type {
        case .integer, .number, .string, .boolean:
            isPrimitive = true
        default:
            isPrimitive = false
        }

        return isPrimitive ? "true" : ""
    }

    static func responseIsPrimitive(value: Any?) throws -> Any? {
        let response: Response
        if let either = value as? Either<Response, Structure<Response>> {
            response = either.structure
        } else if let valueResponse = value as? Response {
            response = valueResponse
        } else {
            throw TemplateSyntaxError("Expected Response")
        }

        return try self.isPrimitive(value: response.schema)
    }
}
