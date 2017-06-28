import Stencil

extension Filters {
    static func setIndentation(value: Any?, arguments: [Any?]) throws -> Any? {
        guard arguments.count < 2 else {
            throw TemplateSyntaxError("'setIndentation' filter takes a single argument")
        }

        guard let value = value as? String, let separator = arguments.first as? String else {
            throw TemplateSyntaxError("Value and separator must be strings")
        }

        let lines = value.components(separatedBy: "\n")
        let newLines = lines.map { $0 == "" ? "" : separator + $0 }
        return newLines.joined(separator: "\n")
    }
}
