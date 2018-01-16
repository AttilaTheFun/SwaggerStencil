import Stencil
import StencilSwiftKit
import SwaggerParser

extension Extension {
    func registerCustomFilters() {
        self.registerFilter("parameterName", filter: Filters.parameterName)

        self.registerFilter("hasParameter", filter: Filters.hasParameter)
        self.registerFilter("hasNonAuthHeaderParameter", filter: Filters.hasNonAuthHeaderParameter)
        self.registerFilter("isParameter", filter: Filters.isParameter)
        self.registerFilter("isStringFormat", filter: Filters.isStringFormat)
        self.registerFilter("handlerName", filter: Filters.handlerName)

        self.registerFilter("hasSchema", filter: Filters.hasSchema)
        self.registerFilter("isPrimitive", filter: Filters.isPrimitive)
        self.registerFilter("isType", filter: Filters.isType)

        self.registerFilter("wrapInCurlyBraces", filter: Filters.wrapInCurlyBraces)
        self.registerFilter("trimWhitespace", filter: Filters.trimWhitespace)
        self.registerFilter("trimTrailingComma", filter: Filters.trimTrailingComma)
        self.registerFilter("removeNewlines", filter: Filters.removeNewlines)
        self.registerFilter("alphabetizeLines", filter: Filters.alphabetizeLines)
        self.registerFilter("pathToPascal", filter: Filters.pathToPascal)
        self.registerFilter("toPascal", filter: Filters.toPascal)
        self.registerFilter("toCamel", filter: Filters.toCamel)
        self.registerFilter("setIndentation", filter: Filters.setIndentation)
        self.registerFilter("wrapWidth", filter: Filters.wrapWidth)

        self.registerTag("import", parser: ImportNode.parse)
        self.registerTag("contains", parser: ContainsNode.parse)
        self.registerTag("notcontains", parser: NotContainsNode.parse)

        // MARK: Golang
        self.registerFilter("golangResponseType", filter: Filters.golangResponseType)
        self.registerFilter("golangSchemaType", filter: Filters.golangSchemaType)
        self.registerFilter("golangParameterType", filter: Filters.golangParameterType)

        // MARK: Swift
        self.registerFilter("swiftResponseType", filter: Filters.swiftResponseType)
        self.registerFilter("swiftSchemaType", filter: Filters.swiftSchemaType)
        self.registerFilter("swiftParameterType", filter: Filters.swiftParameterType)
    }
}
