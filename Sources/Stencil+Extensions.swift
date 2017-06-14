import Stencil
import StencilSwiftKit
import SwaggerParser

extension Extension {
    func registerCustomFilters() {
        self.registerFilter("removeNewlines", filter: Filters.removeNewlines)
        self.registerFilter("pathToPascal", filter: Filters.pathToPascal)
        self.registerFilter("toPascal", filter: Filters.toPascal)
        self.registerFilter("toCamel", filter: Filters.toCamel)
        self.registerTag("import", parser: ImportNode.parse)
    }
}
