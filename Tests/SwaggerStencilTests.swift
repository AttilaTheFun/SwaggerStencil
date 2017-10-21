import XCTest
import SwaggerParser
import Yaml
import PathKit
import Stencil
import StencilSwiftKit
@testable import SwaggerStencil

class SwaggerStencilTests: XCTestCase {
    var stencilExtension: Extension!
    var templateFolderPath: PathKit.Path!
    var golangFullPath: PathKit.Path!
    var swiftFullPath: PathKit.Path!

    override func setUp() {
        // Load extension:
        stencilExtension = Extension()
        stencilExtension.registerStencilSwiftExtensions()
        stencilExtension.registerCustomFilters()

        let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
        let projectRoot = fileURL.deletingLastPathComponent()
        templateFolderPath = Path(projectRoot.path) + "Templates"
        golangFullPath = "/Users/Logan/go/src/github.com/attilathefun"
        swiftFullPath = "/Users/Logan/swift/Snag"
    }

    func testGolang() throws {
        let packageName = "push"
        let fullPath = golangFullPath + packageName
        let relativePath = "github.com/attilathefun/" + packageName
        let swagger = try self.loadSwagger(swaggerPath: fullPath)
        let context = ["swagger": swagger, "path": relativePath] as [String : Any]
        let templatePath = templateFolderPath + "Go"
        self.renderTemplates(templatePath: templatePath, outputPath: fullPath, fileExtension: ".go",
                             context: context)
    }

//    func testSwift() throws {
//        let swagger = try self.loadSwagger(swaggerPath: golangFullPath, isYAML: false, fileName: "merged")
//        let context = ["swagger": swagger] as [String : Any]
//        let templatePath = templateFolderPath + "Swift"
//        self.renderTemplates(templatePath: templatePath, outputPath: swiftFullPath, fileExtension: ".swift",
//                             context: context)
//    }

    private func loadSwagger(swaggerPath: PathKit.Path, isYAML: Bool = true,
                             fileName: String = "swagger") throws -> Swagger
    {
        let fileName = fileName + (isYAML ? ".yaml" : ".json")
        let swaggerFilePath = swaggerPath + fileName
        let swaggerString = try swaggerFilePath.read(.utf8)
        let jsonString: String
        if isYAML {
            let yaml = try Yaml.load(swaggerString)
            let dictionary = try yaml.toDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)!
        } else {
            jsonString = swaggerString
        }

        return try Swagger(from: jsonString)
    }

    private func renderTemplates(templatePath: PathKit.Path, outputPath: PathKit.Path, fileExtension: String,
                                 context: [String : Any])
    {
        let importsPath = templatePath + "Imports"
        let includesPath = templatePath + "Includes"
        let packagesPath = templatePath + "Packages"
        let paths = [
            importsPath,
            includesPath,
            packagesPath
        ]

        // Load environment:
        let loader = FileSystemLoader(paths: paths)
        let environment = Environment(loader: loader, extensions: [self.stencilExtension],
                                      templateClass: Template.self)

        // Generate the code:
        do {
            for packagePath in try packagesPath.children() where packagePath.isDirectory {
                let packageName = packagePath.lastComponent
                let generatedPackagePath = outputPath + packageName
                try generatedPackagePath.mkpath()
                let children = try packagePath.children()
                for filePath in children where filePath.lastComponent.hasSuffix(fileExtension) {
                    let fileName = filePath.lastComponent
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
}
