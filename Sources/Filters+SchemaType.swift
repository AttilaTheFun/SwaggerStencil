import SwaggerParser
import Stencil

extension Filters {
    static func schemaType(value: Any?, arguments: [Any?]) throws -> Any? {
        guard let schema = value as? Schema,
            let languageStringOptional = arguments.first,
            let languageString = languageStringOptional as? String,
            let language = Language(rawValue: languageString) else
        {
            throw TemplateSyntaxError("Expected language arguemnt")
        }

        switch language {
        case .golang:
            return try golangSchemaType(schema: schema) 
        case .swift:
            throw TemplateSyntaxError("Unsupported language")
        }
    }
}
