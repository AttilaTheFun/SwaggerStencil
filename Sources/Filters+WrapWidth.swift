import Foundation
import Stencil

private extension String {
    func wrap(columns: Int = 80) -> String {
        let scanner = Scanner(string: self)

        var result = ""
        var currentLineLength = 0

        var word: NSString?
        while scanner.scanUpToCharacters(from: .whitespacesAndNewlines, into: &word), let word = word {
            let wordLength = word.length

            if currentLineLength != 0 && currentLineLength + wordLength + 1 > columns {
                // too long for current line, wrap
                result += "\n"
                currentLineLength = 0
            }

            // append the word
            if currentLineLength != 0 {
                result += " "
                currentLineLength += 1
            }
            result += word as String
            currentLineLength += wordLength
        }
        
        return result
    }
}

extension Filters {

    static func wrapWidth(value: Any?, arguments: [Any?]) throws -> Any? {
        guard arguments.count != 3 else {
            throw TemplateSyntaxError("'wrapWidth' filter takes three arguments")
        }

        guard let value = value as? String, let widthFloat = arguments.first as? Float,
            let prefix = arguments.dropFirst().first as? String else
        {
            throw TemplateSyntaxError("Value must be a String, width must be an Int, prefix must be a String")
        }

        let width = Int(widthFloat)
        let strideWidth = max(0, width - prefix.characters.count)
        let wrapped = value.wrap(columns: strideWidth)

        return "\n" + wrapped
            .components(separatedBy: "\n")
            .map { prefix + $0 }
            .joined(separator: "\n")
    }
}
