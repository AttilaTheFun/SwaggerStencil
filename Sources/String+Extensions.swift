import Foundation

// MARK: Padding

extension String {

    func padded(to width: Int) -> String {
        if self.characters.count >= width {
            return self
        }

        return self + String(repeating: " ", count: width - self.characters.count)
    }
}

// MARK: Path Parsing

extension String {

    public var stripTemplate: String {
        return String(self[index(after: startIndex) ..< index(before: endIndex)])
    }

    private var isTemplate: Bool {
        return self.hasPrefix("{") && self.hasSuffix("}")
    }

    func pathToPascal() -> String {
        let components = self.components(separatedBy: "/")
        guard components.count > 0 else {
            return ""
        }

        return components.map { $0.isTemplate ? $0.stripTemplate : $0 }
            .map { $0.toPascal() }.joined()
    }
}

// MARK: Encoding Detection

extension String {
    enum NamingStyle {
        case empty
        case inconsistent
        case snake
        case kebab
        case camel
        case pascal
    }

    var namingStyle: NamingStyle {
        guard let first = self.unicodeScalars.first else {
            return .empty
        }

        let containsUnderscore = self.characters.contains("_")
        let containsHyphen = self.characters.contains("-")
        if containsUnderscore && containsHyphen {
            return .inconsistent
        } else if containsUnderscore {
            return .snake
        } else if containsHyphen {
            return .kebab
        }

        if CharacterSet.uppercaseLetters.contains(first) {
            return .pascal
        } else {
            return .camel
        }
    }
}

// MARK: Component Decomposition

extension String {
    fileprivate func components(from style: NamingStyle) -> [String] {
        switch style {
        case .empty, .inconsistent:
            return []
        case .snake:
            return self.componentsFromSnake()
        case .kebab:
            return self.componentsFromKebab()
        case .camel:
            return self.componentsFromCamel()
        case .pascal:
            return self.componentsFromPascal()
        }
    }

    fileprivate init(components: [String], style: NamingStyle) {
        switch style {
        case .empty, .inconsistent:
            self = ""
        case .snake:
            self = String.snake(from: components)
        case .kebab:
            self = String.kebab(from: components)
        case .camel:
            self = String.camel(from: components)
        case .pascal:
            self = String.pascal(from: components)
        }
    }

    public func toKebab() -> String {
        let components = self.components(from: self.namingStyle)
        return String(components: components, style: .kebab)
    }

    public func toSnake() -> String {
        let components = self.components(from: self.namingStyle)
        return String(components: components, style: .snake)
    }

    public func toCamel() -> String {
        let components = self.components(from: self.namingStyle)
        return String(components: components, style: .camel)
    }

    public func toPascal() -> String {
        let components = self.components(from: self.namingStyle)
        return String(components: components, style: .pascal)
    }
}

// MARK: Snake Encoding / Decoding

extension String {
    fileprivate func componentsFromSnake() -> [String] {
        return self.components(separatedBy: "_")
            .map { $0.lowercased() }
    }

    fileprivate static func snake(from components: [String]) -> String {
        return components
            .map { $0.lowercased() }
            .joined(separator: "-")
    }
}

// MARK: Kebab Encoding / Decoding

extension String {

    fileprivate func componentsFromKebab() -> [String] {
        return self.components(separatedBy: "-")
    }

    fileprivate static func kebab(from components: [String]) -> String {
        return components
            .map { $0.pascalComponent() }
            .joined(separator: "-")
    }
}

// MARK: Camel Encoding / Decoding

extension String {

    fileprivate func componentsFromCamel() -> [String] {
        let lowercase = CharacterSet.lowercaseLetters
        let prefix = String(self.unicodeScalars.prefix { lowercase.contains($0) })
        if prefix == self {
            return [prefix]
        }

        let suffix = String(self.unicodeScalars.suffix(self.unicodeScalars.count - prefix.unicodeScalars.count))
        return [prefix] + suffix.componentsFromPascal()
    }

    fileprivate static func camel(from components: [String]) -> String {
        guard let first = components.first else {
            return ""
        }

        let prefix = first.lowercased()
        if components.count == 1 {
            return prefix
        }

        return prefix + self.pascal(from: Array(components.dropFirst()))
    }
}

// MARK: Pascal Encoding / Decoding

extension String {

    fileprivate func componentsFromPascal() -> [String] {
        let uppercase = CharacterSet.uppercaseLetters
        let lowercase = CharacterSet.lowercaseLetters
        var isUppercase = true
        var components = [String]()
        var startIndex = self.unicodeScalars.startIndex
        var currentIndex = self.unicodeScalars.startIndex
        while currentIndex < self.unicodeScalars.endIndex {
            let character = self.unicodeScalars[currentIndex]
            if isUppercase {
                if lowercase.contains(character) {
                    isUppercase = false
                }
            } else {
                if uppercase.contains(character) {
                    components.append(String(self.unicodeScalars[startIndex ..< currentIndex]))
                    startIndex = currentIndex
                }
            }
            currentIndex = self.unicodeScalars.index(after: currentIndex)
        }

        components.append(String(self.unicodeScalars[startIndex ... self.unicodeScalars.endIndex]))

        return components
    }

    fileprivate func pascalComponent() -> String {
        let lowercased = self.lowercased()
        let acronyms = ["id", "uuid", "url"]
        if acronyms.contains(lowercased) {
            return self.uppercased()
        } else if self.last == "s" && acronyms.contains(String(self.dropLast())) {
            return self.dropLast().uppercased() + "s"
        } else {
            return self.capitalized
        }
    }

    fileprivate static func pascal(from components: [String]) -> String {
        return components.map { $0.pascalComponent() }.joined()
    }
}
