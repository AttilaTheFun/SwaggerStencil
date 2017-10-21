import Stencil
import SwaggerParser

extension Filters {
    static func swiftSchemaType(schema: Schema) throws -> String {
        switch schema.type {
        case .structure(let structure):
            return "Models." + structure.name
        case .object(let object):
            return try self.dictionary(properties: object.properties,
                                       additionalProperties: object.additionalProperties)
        case .array(let array):
            switch array.items {
            case .one(let schema):
                return "[\(try swiftSchemaType(schema: schema))]"
            case .many(let schemas):
                return try self.tuple(schemas: schemas)
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
        case .allOf, .file, .enumeration, .null:
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
    
    private static func dictionary(properties: [String: Schema],
                                   additionalProperties: Either<Bool, Schema>) throws -> String
    {
        var schemaType: String?
        for (_, schema) in properties {
            let propertySchemaType = try self.golangSchemaType(schema: schema)
            if schemaType != nil, schemaType != propertySchemaType {
                schemaType = "Any"
            } else {
                schemaType = propertySchemaType
            }
        }
        
        switch additionalProperties {
        case .a(false):
            break
        case .a(true):
            assertionFailure("Additional properties should never be 'true' - if allowed it should be a specific schema.")
        case .b(let schema):
            let propertySchemaType = try self.golangSchemaType(schema: schema)
            if schemaType != nil, schemaType != propertySchemaType {
                schemaType = "Any"
            } else {
                schemaType = propertySchemaType
            }
        }
        
        if let schemaType = schemaType {
            return "[String: \(schemaType)]"
        }
        
        return "[String: Empty]"
    }
    
    private static func tuple(schemas: [Schema]) throws -> String {
        let schemaTypes = try schemas.map { try self.golangSchemaType(schema: $0) }
        return "(\(schemaTypes.joined(separator: ","))"
    }
}

