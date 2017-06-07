import PathKit
import Stencil
import SwaggerParser

struct SwaggerStencil {
    static func loadEnvironment(paths: [String]) -> Environment {
        let loader = FileSystemLoader(paths: paths.map { Path($0) })
        return Environment(loader: loader)
    }
}

extension Swagger {
    func renderTemplate(templateName: String, environment: Environment) throws -> String {
        let context = ["swagger": self]
        return try environment.renderTemplate(name: templateName, context: context)
    }
}
