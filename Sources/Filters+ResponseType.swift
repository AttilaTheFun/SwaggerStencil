import SwaggerParser
import Stencil

extension Filters {
    static func responseType(value: Any?, arguments: [Any?]) throws -> Any? {
        let response: Response
        if let either = value as? Either<Response, Structure<Response>> {
            response = either.structure
        } else if let valueParameter = value as? Response {
            response = valueParameter
        } else {
            throw TemplateSyntaxError("Expected Response")
        }

        guard let languageStringOptional = arguments.first,
            let languageString = languageStringOptional as? String,
            let language = Language(rawValue: languageString) else
        {
            throw TemplateSyntaxError("Expected language arguemnt")
        }

        switch language {
        case .golang:
            return try response.schema.map { try golangSchemaType(schema: $0) } ?? "models.Empty"
        case .swift:
            throw TemplateSyntaxError("Unsupported language")
        }
    }
}
