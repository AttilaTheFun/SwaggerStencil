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
    var mergedSwaggerPath: PathKit.Path!

    var golangSourceRoot: PathKit.Path!
    var golangRelativePath: PathKit.Path!
    var golangFullPath: PathKit.Path!

    var swiftProjectPath: PathKit.Path!

    override func setUp() {
        // Load extension:
        stencilExtension = Extension()
        stencilExtension.registerStencilSwiftExtensions()
        stencilExtension.registerCustomFilters()

        let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
        let projectRoot = fileURL.deletingLastPathComponent()
        templateFolderPath = Path(projectRoot.path) + "Templates"

        golangSourceRoot = "/Users/logan/src/go/src"
        golangRelativePath = "/github.com/aphelionapps/snag/services"
        golangFullPath = golangSourceRoot + golangRelativePath

        swiftProjectPath = "/Users/Logan/src/ios/Snag/Snag"
//        swiftProjectPath = "/Users/Logan/src/ios/TreasureHunt/TreasureHunt"

        mergedSwaggerPath = golangSourceRoot + "github.com/aphelionapps/snag/aphelionapps"
//        mergedSwaggerPath = "/Users/logan/src/ruby/treasurehunt-server"
    }

    func testGolang() throws {
        let packageName = "users"
        let fullPath = golangFullPath + packageName
        let relativePath = golangRelativePath + packageName
        let swagger = try self.loadSwagger(swaggerPath: fullPath)
        let context = ["swagger": swagger, "path": relativePath] as [String : Any]
        let templatePath = templateFolderPath + "Go"
        self.renderTemplates(templatePath: templatePath, outputPath: fullPath, fileExtension: ".go",
                             context: context)
    }

    func testSwift() throws {
        let swagger = try self.loadSwagger(swaggerPath: mergedSwaggerPath, isYAML: false, fileName: "merged")
//        let swagger = try self.loadSwagger(swaggerPath: mergedSwaggerPath, isYAML: true, fileName: "thv1")
        let context = ["swagger": swagger] as [String : Any]
        let templatePath = templateFolderPath + "Swift"
        self.renderTemplates(templatePath: templatePath, outputPath: swiftProjectPath, fileExtension: ".swift",
                             context: context)
    }

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
