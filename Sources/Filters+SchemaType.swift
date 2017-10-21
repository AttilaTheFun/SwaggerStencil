import Stencil
import SwaggerParser

extension Filters {
    static func schemaType(value: Any?, arguments: [Any?]) throws -> Any? {
        let schema: Schema
        if let either = value as? Either<Schema, Structure<Schema>> {
            schema = either.structure
        } else if let valueSchema = value as? Schema {
            schema = valueSchema
        } else {
            throw TemplateSyntaxError("Expected Schema")
        }

        guard let languageStringOptional = arguments.first,
            let languageString = languageStringOptional as? String,
            let language = Language(rawValue: languageString) else
        {
            throw TemplateSyntaxError("Expected language arguemnt")
        }

        switch language {
        case .golang:
            return try golangSchemaType(schema: schema) 
        case .swift:
            return try swiftSchemaType(schema: schema)
        }
    }
}
