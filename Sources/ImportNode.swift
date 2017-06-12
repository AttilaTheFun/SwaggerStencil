import PathKit
import Stencil

class ImportNode : NodeType {
    let templateName: Variable
    let nodes: [NodeType]

    class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
        let bits = token.components()

        guard bits.count == 2 else {
            throw TemplateSyntaxError("'import' tag takes one argument, the template file to be included")
        }

        let scopedNodes = try parser.parse(until(["endimport"]))

        guard parser.nextToken() != nil else {
            throw TemplateSyntaxError("`endimport` was not found.")
        }

        return ImportNode(templateName: Variable(bits[1]), nodes: scopedNodes)
    }

    init(templateName: Variable, nodes: [NodeType]) {
        self.templateName = templateName
        self.nodes = nodes
    }

    func render(_ context: Context) throws -> String {
        guard let templateName = try self.templateName.resolve(context) as? String else {
            throw TemplateSyntaxError("'\(self.templateName)' could not be resolved as a string")
        }

        let template = try context.environment.loadTemplate(name: templateName)
        
        return try context.push {
            let _ = try template.render(context)
            let renderedNodes = try renderNodes(nodes, context)
            return renderedNodes
        }
    }
}
