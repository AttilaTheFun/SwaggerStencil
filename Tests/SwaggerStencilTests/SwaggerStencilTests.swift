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

        let basePath = Path(templateFolderPath + "/Go/Server")
        let importsPath = basePath + "Imports"
        let includesPath = basePath + "Includes"
        let packagesPath = basePath + "Packages"
        let outputPath = basePath + "Generated"

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
        let paths = [
            importsPath,
            includesPath,
            packagesPath
        ]

        let loader = FileSystemLoader(paths: paths)
        let environment = Environment(loader: loader, extensions: [ext],
                                      templateClass: Template.self)

        do {
            for packagePath in try packagesPath.children() where packagePath.isDirectory {
                let packageName = packagePath.lastComponent
                let generatedPackagePath = outputPath + packageName
                try generatedPackagePath.mkpath()

                if packageName != "handlers" {
                    continue
                }

                for filePath in try packagePath.children() where filePath.lastComponent.hasSuffix(".go") {
                    let fileName = filePath.lastComponent
                    let generatedFileName = generatedPackagePath + fileName
                    let templateName = String(describing: Path(packageName) + fileName)

                    let renderedTemplate = try environment.renderTemplate(name: templateName,
                                                                          context: context)
                    try generatedFileName.write(renderedTemplate)
                }
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
