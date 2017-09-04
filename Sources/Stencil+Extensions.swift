import Stencil
import StencilSwiftKit
import SwaggerParser

extension Extension {
    func registerCustomFilters() {
        self.registerFilter("schemaType", filter: Filters.schemaType)
        self.registerFilter("parameterName", filter: Filters.parameterName)
        self.registerFilter("parameterType", filter: Filters.parameterType)
        self.registerFilter("responseType", filter: Filters.responseType)
        self.registerFilter("hasParameter", filter: Filters.hasParameter)
        self.registerFilter("hasSchema", filter: Filters.hasSchema)
        self.registerFilter("isParameter", filter: Filters.isParameter)
        self.registerFilter("handlerName", filter: Filters.handlerName)

        self.registerFilter("removeNewlines", filter: Filters.removeNewlines)
        self.registerFilter("pathToPascal", filter: Filters.pathToPascal)
        self.registerFilter("toPascal", filter: Filters.toPascal)
        self.registerFilter("toCamel", filter: Filters.toCamel)
        self.registerFilter("setIndentation", filter: Filters.setIndentation)
        self.registerFilter("wrapWidth", filter: Filters.wrapWidth)

        self.registerTag("import", parser: ImportNode.parse)
        self.registerTag("contains", parser: ContainsNode.parse)
        self.registerTag("notcontains", parser: NotContainsNode.parse)
    }
}
