import XCTest
import SwaggerParser
import PathKit
import Stencil
import StencilSwiftKit
@testable import SwaggerStencil

class SwaggerStencilTests: XCTestCase {
    var generatedFolderPath: String!
    var templateFolderPath: String!
    var fixtureFolder: URL!

    override func setUp() {
        let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
        generatedFolderPath = fileURL.appendingPathComponent("Generated").path
        templateFolderPath = fileURL.appendingPathComponent("Templates").path
        fixtureFolder = fileURL.appendingPathComponent("Fixtures")
    }

//    func testLyft() throws {
//        // Load context:
//        let url = URL(fileURLWithPath: "/Users/Logan/Downloads/apidocs-master/merged.json")
//        let fixture = try String.init(contentsOf: url, encoding: .utf8)
//        let swagger = try Swagger(JSONString: fixture)
//        let context: [String : Any] = [
//            "swagger": swagger,
//            "path": generatedFolderPath,
//        ]
//
//        // Load environment:
//        let ext = Extension()
//        ext.registerStencilSwiftExtensions()
//        ext.registerCustomFilters()
//        let paths = [
//            Path(templateFolderPath + "/Swift/Client")
//        ]
//        let loader = FileSystemLoader(paths: paths)
//        let environment = Environment(loader: loader, extensions: [ext],
//                                      templateClass: StencilSwiftTemplate.self)
//
//        do {
//            let renderedTemplate = try environment.renderTemplate(name: "Definitions.swift", context: context)
//            print(renderedTemplate)
//        } catch {
//            print(error)
//        }
//    }

    func testExample() throws {

        let templatePath = Path(templateFolderPath + "/Go/Server")
        let outputPath = Path(templateFolderPath + "/Go/Generated")
        try outputPath.mkpath()

        // Load context:
        let fixture = try self.fixture(named: "uber.json")
        let swagger = try Swagger(JSONString: fixture)
        let context: [String : Any] = [
            "swagger": swagger,
            "path": outputPath,
        ]

        // Load environment:
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        ext.registerCustomFilters()
        let loader = FileSystemLoader(paths: [templatePath])
        let environment = Environment(loader: loader, extensions: [ext],
                                      templateClass: Template.self)

        do {
            for path in try templatePath.children() {
                let fileName = path.lastComponent
                if !path.isFile || !fileName.hasSuffix(".go") {
                    continue
                }

                let outputFile = outputPath + fileName
                let renderedTemplate = try environment.renderTemplate(name: fileName, context: context)
                try outputFile.write(renderedTemplate)
            }
        } catch {
            print(error)
        }
    }
}

private extension SwaggerStencilTests {
    func fixture(named fileName: String) throws -> String {
        let url = fixtureFolder.appendingPathComponent(fileName)
        return try String.init(contentsOf: url, encoding: .utf8)
    }
}
