import SwaggerParser

extension DataType: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension OperationType: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension CollectionFormat: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension Parameter {
    public var fixedFields: FixedParameterFields {
        switch self {
        case .body(let fixedFields, _):
            return fixedFields
        case .other(let fixedFields, _):
            return fixedFields
        }
    }
}

extension Either {
    public var structure: A! {
        switch self {
        case .a(let a):
            return a
        case .b(let b):
            return (b as? Structure<A>)?.structure
        }
    }
}

extension ParameterLocation: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension NumberFormat: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension StringFormat: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension IntegerFormat: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
