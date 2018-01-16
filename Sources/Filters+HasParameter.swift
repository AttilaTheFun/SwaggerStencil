import Stencil
import SwaggerParser

extension Filters {
    static func hasNonAuthHeaderParameter(value: Any?) throws -> Any? {
        if let operation = value as? Operation {
            let headerParameters = operation.parameters.filter { $0.structure.fixedFields.location == .header }
            if headerParameters.count == 0 {
                return ""
            } else if headerParameters.count > 1 {
                return "true"
            } else if let name = headerParameters.first?.structure.fixedFields.name, name == "Authenticated-User-ID" {
                return ""
            } else {
                return ""
            }
        }

        throw TemplateSyntaxError("Expected Operation as value")
    }

    static func hasParameter(value: Any?, arguments: [Any?]) throws -> Any? {
        guard let locationString = (arguments.first ?? nil) as? String,
            let location = ParameterLocation(rawValue: locationString) else
        {
            throw TemplateSyntaxError("Expected ParameterLocation as argument")
        }

        if let operation = value as? Operation {
            return self.operation(operation, hasParameterIn: location)
        } else if let swagger = value as? Swagger {
            return self.swagger(swagger, hasParameterIn: location)
        }

        throw TemplateSyntaxError("Expected either Operation or Swagger as value")
    }

    private static func operation(_ operation: Operation,
                                  hasParameterIn location: ParameterLocation) -> String
    {
        let hasParameter = operation.parameters.contains { $0.structure.fixedFields.location == location }
        return hasParameter ? "true" : ""
    }

    private static func swagger(_ swagger: Swagger,
                                  hasParameterIn location: ParameterLocation) -> String
    {
        let hasParameter = swagger.paths.values.contains { path in
            return path.operations.values.contains { operation in
                return operation.parameters.contains { $0.structure.fixedFields.location == location }
            }
        }

        return hasParameter ? "true" : ""
    }

    static func isParameter(value: Any?, arguments: [Any?]) throws -> Any? {
        let parameter = try self.parameter(forValue: value)
        guard let locationString = (arguments.first ?? nil) as? String,
            let location = ParameterLocation(rawValue: locationString) else
        {
            throw TemplateSyntaxError("Invalid Parameter Location")
        }

        let isParameter = parameter.fixedFields.location == location
        return isParameter ? "true" : ""
    }
}
