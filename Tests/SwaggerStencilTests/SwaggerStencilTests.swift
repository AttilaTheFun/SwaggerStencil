import XCTest
import SwaggerParser
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
        let fixture = try self.fixture(named: "uber.json")
        let swagger = try Swagger(JSONString: fixture)
        let environment = SwaggerStencil.loadEnvironment(paths: [testTemplateFolderPath])
        let renderedTemplate = try swagger.renderTemplate(templateName: "Definitions.swift",
                                                          environment: environment)
        print(renderedTemplate)
    }
}

private extension SwaggerStencilTests {
    func fixture(named fileName: String) throws -> String {
        let url = testFixtureFolder.appendingPathComponent(fileName)
        return try String.init(contentsOf: url, encoding: .utf8)
    }
}
