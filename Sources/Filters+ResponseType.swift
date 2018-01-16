import Stencil
import SwaggerParser

extension Filters {
    static func golangResponseType(value: Any?, arguments: [Any?]) throws -> Any? {
        let response = try self.response(fromValue: value)
        var includeModels = true
        if let includeModelsFloat = arguments.first as? Float, includeModelsFloat <= 0 {
            includeModels = false
        }

        if let schema = response.schema {
            return try self.golangSchemaType(schema: schema, includeModels: includeModels)
        } else {
            return includeModels ? "models.Empty" : "Empty"
        }
    }

    static func swiftResponseType(value: Any?) throws -> Any? {
        let response = try self.response(fromValue: value)
        return try response.schema.map { try self.swiftSchemaType(schema: $0) } ?? "Void"
    }

    static func response(fromValue value: Any?) throws -> Response {
        if let either = value as? Either<Response, Structure<Response>> {
            return either.structure
        } else if let valueParameter = value as? Response {
            return valueParameter
        } else {
            throw TemplateSyntaxError("Expected Response")
        }
    }
}
