import SwaggerParser
import Stencil

extension Filters {
    static func handlerName(value: Any?, arguments: [Any?]) throws -> Any? {
        guard let path = value as? String,
            let operationTypeStringOptional = arguments.first,
            let operationTypeString = operationTypeStringOptional as? String,
            let operationType = OperationType(rawValue: operationTypeString) else
        {
            throw TemplateSyntaxError("Expected path and operation type")
        }

        return operationType.rawValue.toPascal() + path.pathToPascal()
    }
}
