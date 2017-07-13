import SwaggerParser
import Stencil

extension Filters {
    static func parameterName(value: Any?) throws -> Any? {
        let parameter: Parameter
        if let either = value as? Either<Parameter, Structure<Parameter>> {
            parameter = either.structure
        } else if let valueParameter = value as? Parameter {
            parameter = valueParameter
        } else {
            throw TemplateSyntaxError("Expected Parameter")
        }

        return parameter.fixedFields.name
    }
}

