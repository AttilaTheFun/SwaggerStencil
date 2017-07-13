import SwaggerParser
import Stencil

extension Filters {
    static func hasParameter(value: Any?, arguments: [Any?]) throws -> Any? {
        guard let operation = value as? Operation,
            let locationString = (arguments.first ?? nil) as? String,
            let location = ParameterLocation(rawValue: locationString) else
        {
            throw TemplateSyntaxError("Expected Operation")
        }

        return operation.parameters.contains { $0.structure.fixedFields.location == location }
    }

    static func isParameter(value: Any?, arguments: [Any?]) throws -> Any? {
        let parameter: Parameter
        if let either = value as? Either<Parameter, Structure<Parameter>> {
            parameter = either.structure
        } else if let valueParameter = value as? Parameter {
            parameter = valueParameter
        } else {
            throw TemplateSyntaxError("Expected Parameter")
        }

        guard let locationString = (arguments.first ?? nil) as? String,
            let location = ParameterLocation(rawValue: locationString) else
        {
            throw TemplateSyntaxError("Invalid Parameter Location")
        }

        return parameter.fixedFields.location == location
    }
}