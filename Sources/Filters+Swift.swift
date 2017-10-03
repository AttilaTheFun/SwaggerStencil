import Stencil
import SwaggerParser

extension Filters {
    static func swiftSchemaType(schema: Schema) throws -> String {
        switch schema.type {
        case .structure(let structure):
            return "Models." + structure.name
        case .array(let array):
            switch array.items {
            case .one(let schema):
                return "[\(try swiftSchemaType(schema: schema))]"
            case .many:
                throw TemplateSyntaxError("Unsupported schema type")
            }
        case .number(let format):
            switch format {
            case .some(.float):
                return "Float"
            case .some(.double), .none:
                return "Double"
            }
        case .integer(let format):
            switch format {
            case .some(.int32):
                return "Int32"
            case .some(.int64):
                return "Int64"
            case .none:
                return "Int"
            }
        case .string:
            return "String"
        case .boolean:
            return "Bool"
        case .any:
            return "Any"
        case .allOf, .file, .enumeration, .object, .null:
            throw TemplateSyntaxError("Unsupported schema type")
        }
    }

    static func swiftItemsType(items: Items) throws -> String {
        switch items.type {
        case .array(let array):
            return "[\(try swiftItemsType(items: array.items))]"
        case .number(let item):
            switch item.format {
            case .some(.float):
                return "Float"
            case .some(.double), .none:
                return "Double"
            }
        case .integer(let item):
            switch item.format {
            case .some(.int32):
                return "Int32"
            case .some(.int64):
                return "Int64"
            case .none:
                return "Int"
            }
        case .string:
            return "String"
        case .boolean:
            return "Bool"
        }
    }
}

