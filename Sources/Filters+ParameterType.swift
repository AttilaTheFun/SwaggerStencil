import Stencil
import SwaggerParser

extension Filters {
    static func golangParameterType(value: Any?, arguments: [Any?]) throws -> Any? {
        let parameter = try self.parameter(forValue: value)
        switch parameter {
        case .body(_, let schema):
            return try self.golangSchemaType(schema: schema, includeModels: true)
        case .other(_, let items):
            return try self.golangItemsType(items: items)
        }
    }

    static func swiftParameterType(value: Any?, arguments: [Any?]) throws -> Any? {
        let parameter = try self.parameter(forValue: value)
        switch parameter {
        case .body(_, let schema):
            return try self.swiftSchemaType(schema: schema)
        case .other(_, let items):
            return try self.swiftItemsType(items: items)
        }
    }

    static func parameter(forValue value: Any?) throws -> Parameter {
        if let either = value as? Either<Parameter, Structure<Parameter>> {
            return either.structure
        } else if let valueParameter = value as? Parameter {
            return valueParameter
        } else {
            throw TemplateSyntaxError("Expected Parameter")
        }
    }
}
