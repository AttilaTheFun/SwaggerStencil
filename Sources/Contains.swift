import PathKit
import Stencil

/// Used to render nested nodes only if the given array contains the given value.
class ContainsNode : NodeType {
    let arrayName: Variable
    let value: String
    let nodes: [NodeType]

    class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
        let bits = token.components()

        guard bits.count == 3 else {
            throw TemplateSyntaxError("'contains' tag takes three argument")
        }

        let scopedNodes = try parser.parse(until(["endcontains"]))

        guard parser.nextToken() != nil else {
            throw TemplateSyntaxError("`endcontains` was not found.")
        }

        return ContainsNode(arrayName: Variable(bits[1]), value: bits[2], nodes: scopedNodes)
    }

    init(arrayName: Variable, value: String, nodes: [NodeType]) {
        self.arrayName = arrayName
        self.value = value
        self.nodes = nodes
    }

    func render(_ context: Context) throws -> String {
        guard let array = try self.arrayName.resolve(context) as? [String] else {
            throw TemplateSyntaxError("'\(self.arrayName)' could not be resolved as an array of strings")
        }

        if array.contains(self.value) {
            return try context.push {
                let renderedNodes = try renderNodes(nodes, context)
                return renderedNodes
            }
        }

        return ""
    }
}

/// Used to render nested nodes only if the given array doesn't contin the given value.
class NotContainsNode : NodeType {
    let arrayName: Variable
    let value: String
    let nodes: [NodeType]

    class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
        let bits = token.components()

        guard bits.count == 3 else {
            throw TemplateSyntaxError("'notcontains' tag takes two arguments")
        }

        let scopedNodes = try parser.parse(until(["endnotcontains"]))

        guard parser.nextToken() != nil else {
            throw TemplateSyntaxError("`endnotcontains` was not found.")
        }

        return NotContainsNode(arrayName: Variable(bits[1]), value: bits[2], nodes: scopedNodes)
    }

    init(arrayName: Variable, value: String, nodes: [NodeType]) {
        self.arrayName = arrayName
        self.value = value
        self.nodes = nodes
    }

    func render(_ context: Context) throws -> String {
        guard let array = try self.arrayName.resolve(context) as? [String] else {
            throw TemplateSyntaxError("'\(self.arrayName)' could not be resolved as an array of strings")
        }

        if !array.contains(self.value) {
            return try context.push {
                let renderedNodes = try renderNodes(nodes, context)
                return renderedNodes
            }
        }
        
        return ""
    }
}
