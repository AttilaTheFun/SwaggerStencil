import Stencil
import StencilSwiftKit
import SwaggerParser

extension Extension {
    func registerCustomFilters() {
        self.registerFilter("removeNewlines", filter: Filters.removeNewlines)
        self.registerFilter("toPascal", filter: Filters.toPascal)
        self.registerFilter("pathToPascal", filter: Filters.pathToPascal)
        self.registerTag("import", parser: ImportNode.parse)
    }
}
