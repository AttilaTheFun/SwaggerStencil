import Stencil
import SwaggerParser

extension Filters {
    static func parameterName(value: Any?) throws -> Any? {
        let parameter = try self.parameter(forValue: value)
        return parameter.fixedFields.name
    }
}
