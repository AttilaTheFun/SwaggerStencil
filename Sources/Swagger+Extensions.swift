import SwaggerParser

extension OperationType: CustomStringConvertible {
    public var description: String {
        return self.rawValue
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
