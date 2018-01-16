import Stencil
import SwaggerParser

extension Filters {
    static func golangSchemaType(schema: Schema, includeModels: Bool) throws -> String {
        switch schema.type {
        case .structure(let structure) where includeModels:
            return "models." + structure.name
        case .structure(let structure):
            return structure.name
        case .object(let object):
            return try dictionary(properties: object.properties, additionalProperties: object.additionalProperties,
                                  includeModels: includeModels)
        case .array(let array):
            switch array.items {
            case .one(let schema):
                return "[]\(try self.golangSchemaType(schema: schema, includeModels: includeModels))"
            case .many(let schemas):
                return try self.anonymousStruct(schemas: schemas, includeModels: includeModels)
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
        case .allOf, .file, .enumeration, .null:
            throw TemplateSyntaxError("Unsupported schema type")
        }
    }

    static func golangItemsType(items: Items) throws -> String {
        switch items.type {
        case .array(let array):
            return "[]\(try self.golangItemsType(items: array.items))"
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

    private static func dictionary(properties: [String: Schema],
                                   additionalProperties: Either<Bool, Schema>,
                                   includeModels: Bool) throws -> String
    {
        var schemaType: String?
        for (_, schema) in properties {
            let propertySchemaType = try self.golangSchemaType(schema: schema, includeModels: includeModels)
            if schemaType != nil, schemaType != propertySchemaType {
                schemaType = "interface{}"
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
            let propertySchemaType = try self.golangSchemaType(schema: schema, includeModels: includeModels)
            if schemaType != nil, schemaType != propertySchemaType {
                schemaType = "interface{}"
            } else {
                schemaType = propertySchemaType
            }
        }

        if let schemaType = schemaType {
            return "map[string]\(schemaType)"
        }
        
        return "map[string]empty"
    }
    
    private static func anonymousStruct(schemas: [Schema], includeModels: Bool) throws -> String {
        let schemaTypes = try schemas.map { try self.golangSchemaType(schema: $0, includeModels: includeModels) }
        return "struct {\(schemaTypes.joined(separator: ";"));}"
    }
}
