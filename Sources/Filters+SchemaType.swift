import Stencil
import SwaggerParser

extension Filters {
    static func golangSchemaType(value: Any?, arguments: [Any?]) throws -> Any? {
        let schema = try self.schema(forValue: value)
        var includeModels = true
        if let includeModelsFloat = arguments.first as? Float, includeModelsFloat <= 0 {
            includeModels = false
        }

        return try self.golangSchemaType(schema: schema, includeModels: includeModels)
    }

    static func swiftSchemaType(value: Any?) throws -> Any? {
        let schema = try self.schema(forValue: value)
        return try self.swiftSchemaType(schema: schema)
    }

    static func schema(forValue value: Any?) throws -> Schema {
        if let either = value as? Either<Schema, Structure<Schema>> {
            return either.structure
        } else if let valueSchema = value as? Schema {
            return valueSchema
        } else if let response = try? self.response(fromValue: value) {
            if let schema = response.schema {
                return schema
            } else {
                throw TemplateSyntaxError("Expected response schema")
            }
        } else {
            throw TemplateSyntaxError("Expected Schema")
        }
    }
}
