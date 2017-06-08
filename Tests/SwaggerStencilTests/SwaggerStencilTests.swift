import XCTest
import SwaggerParser
@testable import SwaggerStencil

struct Foo<T> {
    let item: T
}

struct Bar {
    let foos: [Foo<String>]
}

enum NormalEnum {
    case foo
    case bar
}

enum FooOrBar {
    case foo(Foo<String>)
    case bar(Bar)
}

class SwaggerStencilTests: XCTestCase {
    var testTemplateFolderPath: String!
    var testFixtureFolder: URL!

    override func setUp() {
        let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
        testTemplateFolderPath = fileURL.appendingPathComponent("Templates").path
        testFixtureFolder = fileURL.appendingPathComponent("Fixtures")
    }

    func testTypes() throws {
        let environment = SwaggerStencil.loadEnvironment(paths: [testTemplateFolderPath])
        let bar = Bar(foos: [Foo(item: "1"), Foo(item: "2")])
        let context = [
            "bar": FooOrBar.bar(bar)
        ]

        do {
            let renderedTemplate = try environment.renderTemplate(name: "Definitions.swift", context: context)
            print(renderedTemplate)
        } catch {
            print(error)
        }
    }

    func testExample() throws {
        let fixture = try self.fixture(named: "uber.json")
        let swagger = try Swagger(JSONString: fixture)
        let environment = SwaggerStencil.loadEnvironment(paths: [testTemplateFolderPath])

        do {
            let renderedTemplate = try swagger.renderTemplate(templateName: "Definitions.swift",
                                                          environment: environment)
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
