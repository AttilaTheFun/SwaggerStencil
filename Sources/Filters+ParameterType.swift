import Stencil
import SwaggerParser

extension Filters {
    static func parameterType(value: Any?, arguments: [Any?]) throws -> Any? {
        let parameter: Parameter
        if let either = value as? Either<Parameter, Structure<Parameter>> {
            parameter = either.structure
        } else if let valueParameter = value as? Parameter {
            parameter = valueParameter
        } else {
            throw TemplateSyntaxError("Expected Parameter")
        }

        guard let languageStringOptional = arguments.first,
            let languageString = languageStringOptional as? String,
            let language = Language(rawValue: languageString) else
        {
            throw TemplateSyntaxError("Expected language arguemnt")
        }

        switch language {
        case .golang:
            switch parameter {
            case .body(_, let schema):
                return try golangSchemaType(schema: schema)
            case .other(_, let items):
                return try golangItemsType(items: items)
            }
        case .swift:
            switch parameter {
            case .body(_, let schema):
                return try swiftSchemaType(schema: schema)
            case .other(_, let items):
                return try swiftItemsType(items: items)
            }
        }
    }
}
