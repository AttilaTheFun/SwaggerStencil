import Stencil
import SwaggerParser

extension Filters {
    static func golangSchemaType(schema: Schema) throws -> String {
        switch schema.type {
        case .structure(let structure):
            return "models." + structure.name
        case .object(let object):
            return try anonymousStruct(properties: object.properties)
        case .array(let array):
            switch array.items {
            case .one(let schema):
                return "[]\(try golangSchemaType(schema: schema))"
            case .many(let schemas):
                return try anonymousStruct(anonymousFields: schemas)
            }
        case .number(let format):
            switch format {
            case .some(.float):
                return "float32"
            case .some(.double), .none:
                return "float64"
            }
        case .integer(let format):
            switch format {
            case .some(.int32):
                return "int32"
            case .some(.int64):
                return "int64"
            case .none:
                return "int"
            }
        case .string:
            return "string"
        case .boolean:
            return "bool"
        case .any:
            return "interface{}"
        case .allOf, .file, .enumeration:
            throw TemplateSyntaxError("Unsupported schema type")
        }
    }

    static func golangItemsType(items: Items) throws -> String {
        switch items.type {
        case .array(let array):
            return "[]\(try golangItemsType(items: array.items))"
        case .number(let item):
            switch item.format {
            case .some(.float):
                return "float32"
            case .some(.double), .none:
                return "float64"
            }
        case .integer(let item):
            switch item.format {
            case .some(.int32):
                return "int32"
            case .some(.int64):
                return "int64"
            case .none:
                return "int"
            }
        case .string:
            return "string"
        case .boolean:
            return "bool"
        }
    }

    private static func anonymousStruct(properties: [String: Schema] = [:],
                                        anonymousFields: [Schema] = []) throws -> String
    {
        var properties = try properties.map { "\($0.toPascal()) \(try golangSchemaType(schema: $1))"}
        properties += try anonymousFields.map { try golangSchemaType(schema: $0) }
        return "struct {\(properties.joined(separator: ";"));}"
    }
}
