import Yaml

struct DecodingError: Error {
    init() {
        print("Yaml decoding error")
    }
}

extension Yaml {
    func toAny() throws -> Any {
        switch self {
        case .string(let string):
            return string
        case .bool(let bool):
            return bool
        case .int(let int):
            return int
        case .double(let double):
            return double
        case .array:
            return try self.toArray()
        case .dictionary:
            return try self.toDictionary()
        case .null:
            throw DecodingError()
        }
    }

    func toArray() throws -> [Any] {
        guard case .array(let yamlArray) = self else {
            throw DecodingError()
        }

        return try yamlArray.map { try $0.toAny() }
    }

    func toDictionary() throws -> [String : Any] {
        guard case .dictionary(let yamlDictionary) = self else {
            throw DecodingError()
        }

        var dictionary = [String : Any]()
        for (yamlKey, yamlValue) in yamlDictionary {
            guard case .string(let key) = yamlKey else {
                throw DecodingError()
            }

            dictionary[key] = try yamlValue.toAny()
        }
        
        return dictionary
    }
}
