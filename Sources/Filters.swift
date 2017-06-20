import Foundation
import Stencil

enum Filters {
    enum Error: Swift.Error {
        case invalidInputType
    }

    private static func width(for index: Int, rows: [[String]]) -> Int {
        return rows.reduce(0) { return max($0, $1[index].characters.count) }
    }

    private static func commentTuples(from string: String) -> [(String?, String)] {
        let cleanedString = string.replacingOccurrences(of: "\u{b}", with: "")
            .trimmingCharacters(in: .newlines)
        let allLines = cleanedString.components(separatedBy: .newlines)
        var commentTuples = [(String?, String)]()
        var lastWasComment = false
        for (index, line) in allLines.enumerated() {
            if line.hasPrefix("// ") {
                lastWasComment = true
            } else {
                let comment = lastWasComment ? allLines[index - 1] : nil
                commentTuples.append((comment, line))
                lastWasComment = false
            }
        }

        return commentTuples
    }

    static func alignColumns(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        let commentTuples = self.commentTuples(from: string)
        let tuplesWithComments = commentTuples.flatMap { $0.0 == nil ? nil : ($0.0!, $0.1) }
        let linesWithoutComments = commentTuples.flatMap { $0.0 == nil ? $0.1 : nil }

        let rows = linesWithoutComments.map { $0.components(separatedBy: .whitespaces) }
        let numColumns = rows.reduce(0) { max($0, $1.count) }
        let columnWidths = (0..<numColumns).map { width(for: $0, rows: rows) }
        let uncommentedLines = rows.map { row in
            return row.enumerated()
                .map { $1.padded(to: columnWidths[$0]) }
                .joined(separator: " ")
        }

        let commentedLines = tuplesWithComments.map { "\n\($0)\n\($1)" }
        var allLines = [String]()
        allLines += commentedLines.count > 0 ? [""] + commentedLines : []

        let uncommentedSpacer = commentedLines.count > 0 ? [""] : []
        allLines += uncommentedLines.count > 0 ? uncommentedSpacer + uncommentedLines : []

        let joinedLines = allLines.joined(separator: "\n")
        return joinedLines.characters.first == "\n" ? joinedLines : "\n" + joinedLines
    }

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

    static func removeNewlines(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.components(separatedBy: "\n").joined()
    }

    static func pathToPascal(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.pathToPascal()
    }

    static func toPascal(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toPascal()
    }

    static func toCamel(_ value: Any?) throws -> Any? {
        guard let string = value as? String else { throw Filters.Error.invalidInputType }
        return string.toCamel()
    }
}
