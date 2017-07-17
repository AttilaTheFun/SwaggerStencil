import XCTest
import SwaggerParser
import Yaml
import PathKit
import Stencil
import StencilSwiftKit
@testable import SwaggerStencil

class SwaggerStencilTests: XCTestCase {
    var generatedFolderPath: PathKit.Path!
    var golangPackagePath: PathKit.Path!
    var templateFolderPath: PathKit.Path!

    override func setUp() {
        let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
        templateFolderPath = Path(fileURL.path) + "Templates"

        let sourcePath = Path("/Users/Logan/go/src/")
        golangPackagePath = Path("github.com/attilathefun/test")
        generatedFolderPath = sourcePath + golangPackagePath
    }

    func testExample() throws {

        // Load context:
        let swaggerFilePath = generatedFolderPath + "swagger.yaml"
        let swaggerString = try swaggerFilePath.read(.utf8)
        let yaml = try Yaml.load(swaggerString)
        let dictionary = try yaml.toDictionary()
        let swagger = try Swagger(JSON: dictionary)
        let context: [String : Any] = [
            "swagger": swagger,
            "path": golangPackagePath.string,
        ]

        // Load extension:
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        ext.registerCustomFilters()

        // Load paths:
        let basePath = templateFolderPath + "Go/Server"
        let importsPath = basePath + "Imports"
        let includesPath = basePath + "Includes"
        let packagesPath = basePath + "Packages"
        let paths = [
            importsPath,
            includesPath,
            packagesPath
        ]

        // Load environment:
        let loader = FileSystemLoader(paths: paths)
        let environment = Environment(loader: loader, extensions: [ext],
                                      templateClass: Template.self)

        // Generate the code:
        do {
            for packagePath in try packagesPath.children() where packagePath.isDirectory {
                let packageName = packagePath.lastComponent
                let generatedPackagePath = generatedFolderPath + packageName
                try generatedPackagePath.mkpath()

                for filePath in try packagePath.children() where filePath.lastComponent.hasSuffix(".go") {
                    let fileName = filePath.lastComponent

                    if fileName != "handlers.go" {
                        continue
                    }

                    let generatedFileName = generatedPackagePath + fileName
                    let templateName = String(describing: Path(packageName) + fileName)

                    let renderedTemplate = try environment.renderTemplate(name: templateName,
                                                                          context: context)
                    print(renderedTemplate)
                    try generatedFileName.write(renderedTemplate)
                }
            }
        } catch {
            print(error)
        }
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
}
