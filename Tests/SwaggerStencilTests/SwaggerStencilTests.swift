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
        let fixture = try self.fixture(named: "uber.json")
        let swagger = try Swagger(JSONString: fixture)
        let context: [String : Any] = ["swagger": swagger]

        var environment = stencilSwiftEnvironment()
        environment.loader = FileSystemLoader(paths: [Path(testTemplateFolderPath)])

        do {
            let renderedTemplate = try environment.renderTemplate(name: "Definitions.swift", context: context)
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
