import XCTest
import SwaggerParser
import PathKit
import Stencil
import StencilSwiftKit
@testable import SwaggerStencil

class SwaggerStencilTests: XCTestCase {
    var testTemplateFolderPath: String!
    var testFixtureFolder: URL!

    override func setUp() {
        let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
        testTemplateFolderPath = fileURL.appendingPathComponent("Templates").path
        testFixtureFolder = fileURL.appendingPathComponent("Fixtures")
    }

    func testExample() throws {

        // Load context:
        let fixture = try self.fixture(named: "uber.json")
        let swagger = try Swagger(JSONString: fixture)
        let context: [String : Any] = ["swagger": swagger]

        // Load environment:
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        ext.registerCustomFilters()
        let paths = [
            Path(testTemplateFolderPath + "/Go/Server")
        ]
        let loader = FileSystemLoader(paths: paths)
        let environment = Environment(loader: loader, extensions: [ext],
                                      templateClass: StencilSwiftTemplate.self)

        do {
            let renderedTemplate = try environment.renderTemplate(name: "models.go", context: context)
            print(renderedTemplate)
        } catch {
            print(error)
        }
    }
}

private extension SwaggerStencilTests {
    func fixture(named fileName: String) throws -> String {
        let url = testFixtureFolder.appendingPathComponent(fileName)
        return try String.init(contentsOf: url, encoding: .utf8)
    }
}
