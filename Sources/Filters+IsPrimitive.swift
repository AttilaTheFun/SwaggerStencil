import Stencil
import SwaggerParser

extension Filters {
    static func isPrimitive(value: Any?) throws -> Any? {
        let schema = try self.schema(forValue: value)
        let isPrimitive: Bool
        switch schema.type {
        case .integer, .number, .string, .boolean:
            isPrimitive = true
        default:
            isPrimitive = false
        }

        return isPrimitive ? "true" : ""
    }

    static func isType(value: Any?, arguments: [Any?]) throws -> Any? {
        let metadata: Metadata
        if let either = value as? Either<Schema, Structure<Schema>> {
            metadata = either.structure.metadata
        } else if let value = value as? Schema {
            metadata = value.metadata
        } else if let either = value as? Either<Items, Structure<Items>> {
            metadata = either.structure.metadata
        } else if let value = value as? Items {
            metadata = value.metadata
        } else {
            throw TemplateSyntaxError("Expected Schema")
        }

        guard let typeString = arguments.first as? String, let type = DataType(rawValue: typeString) else {
            throw TemplateSyntaxError("Argument must be raw data type")
        }

        return metadata.type == type
    }
}
