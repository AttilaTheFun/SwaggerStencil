import Stencil
import SwaggerParser

extension Filters {
    static func hasSchema(value: Any?) throws -> Any? {
        let response = try self.response(fromValue: value)
        let hasSchema = response.schema != nil
        return hasSchema ? "true" : ""
    }
}
