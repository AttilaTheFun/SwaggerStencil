import Stencil
import StencilSwiftKit
import SwaggerParser

extension Extension {
    func registerCustomFilters() {
        self.registerFilter("removeNewlines", filter: Filters.removeNewlines)
        self.registerFilter("pathToPascal", filter: Filters.pathToPascal)
        self.registerFilter("toPascal", filter: Filters.toPascal)
        self.registerFilter("toCamel", filter: Filters.toCamel)
        self.registerFilter("setIndentation", filter: Filters.setIndentation)
        self.registerFilter("alignColumns", filter: Filters.alignColumns)
        self.registerTag("import", parser: ImportNode.parse)
        self.registerTag("contains", parser: ContainsNode.parse)
        self.registerTag("notcontains", parser: NotContainsNode.parse)
    }
}
