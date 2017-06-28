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
