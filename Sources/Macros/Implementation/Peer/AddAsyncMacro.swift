//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AddAsyncMacro: PeerMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // Only on functions at the moment
        guard
            var funcDecl = declaration.as(FunctionDeclSyntax.self)
        else {
            throw CustomError.message("@addAsync only works on functions")
        }
        
        // This only makes sense for non async functions
        guard
            funcDecl.signature.effectSpecifiers?.asyncSpecifier == nil
        else {
            throw CustomError.message("@addAsync requires an non async function")
        }
        
        // This only makes sense void functions
        guard
            funcDecl.signature.returnClause?.type
                .as(IdentifierTypeSyntax.self)?
                .name.text == "Void"
        else {
            throw CustomError.message("@addAsync requires an function that returns void")
        }
        
        // Requires a completion handler block as last parameter
        guard
            let completionHandlerParameter = funcDecl
                .signature
                .parameterClause
                .parameters.last?
                .type.as(AttributedTypeSyntax.self)?
                .baseType.as(FunctionTypeSyntax.self)
        else {
            throw CustomError.message("@addAsync requires an function that has a completion handler as last parameter")
        }
        
        // CompletionHandler needs to return void
        guard
            completionHandlerParameter.returnClause
                .type.as(IdentifierTypeSyntax.self)?
                .name.text == "Void"
        else {
            throw CustomError.message("@addAsync requires an function that has a completionHandler that returns void")
        }
        
        let returnType = completionHandlerParameter.parameters
            .first?.type
            .as(IdentifierTypeSyntax.self)
        
        let isResultReturn = returnType?.name.text == "Result"
        
        let successReturnType = if isResultReturn {
            returnType!.genericArgumentClause?
                .arguments.first!.argument
                .as(IdentifierTypeSyntax.self)
        } else {
            returnType
        }
        
        // Remove completionHandler and comma from the previous praramter
        var newParameterList = funcDecl.signature.parameterClause.parameters
        newParameterList.removeLast()
        var newParameterListLastParameter = newParameterList.last!
        newParameterList.removeLast()
        newParameterListLastParameter.trailingTrivia = []
        newParameterListLastParameter.trailingComma = nil
        newParameterList.append(newParameterListLastParameter)
        
        // Drop the @addAsync attribute from the new declaration
        let newAttributeList = funcDecl.attributes.filter { attribute in
            guard
                let attribute = attribute.as(AttributeSyntax.self),
                let attributeType = attribute.attributeName.as(IdentifierTypeSyntax.self),
                let nodeType = node.attributeName.as(IdentifierTypeSyntax.self)
            else { return true }
            
            return attributeType.name.text != nodeType.name.text
        }
        
        let callArguments: [String] = newParameterList.map { parameter in
            let argName = parameter.secondName ?? parameter.firstName
            
            let paramName = parameter.firstName
            if paramName.text != "_" {
                return "\(paramName.text): \(argName.text)"
            }
            
            return "\(argName.text)"
        }
        
        let switchBody: ExprSyntax =
        """
        switch returnValue {
            case let .success(value):
                continuation.resume(returning: value)
            case let .failure(error):
                continuation.resume(throwing: error)
        }
        """
        
        let continuationExpr = isResultReturn ? "try await withCheckedThrowingContinuation { continuation in" : "await withCheckedContinuation { continuation in"
        
        let continuationBody: ExprSyntax =
        """
        \(raw: continuationExpr)
            \(funcDecl.name)(\(raw: callArguments.joined(separator: ", "))) { \(raw: returnType != nil ? "returnValue in" : "")
        
        \(raw: isResultReturn ? switchBody : "continuation.resume(returning: \(raw: returnType != nil ? "returnValue" : "()"))")
            }
        }
        """
        
        // add async
        funcDecl.signature.effectSpecifiers = FunctionEffectSpecifiersSyntax(
            leadingTrivia: .space,
            asyncSpecifier: .keyword(.async),
            throwsSpecifier: isResultReturn ? .keyword(.throws) : nil
        )
        
        // add result type
        if let successReturnType {
            funcDecl.signature.returnClause = ReturnClauseSyntax(
                leadingTrivia: .space,
                type: successReturnType.with(\.trailingTrivia, .space)
            )
        } else {
            funcDecl.signature.returnClause = nil
        }
        
        // drop completion handler
        funcDecl.signature.parameterClause.parameters = newParameterList
        funcDecl.signature.parameterClause.trailingTrivia = []
        
        funcDecl.body = CodeBlockSyntax(
            leftBrace: .leftBraceToken(leadingTrivia: .space),
            statements: CodeBlockItemListSyntax([
                CodeBlockItemSyntax(item: .expr(continuationBody))
            ]),
            rightBrace: .rightBraceToken(leadingTrivia: .newline)
        )
        
        funcDecl.attributes = newAttributeList
        funcDecl.leadingTrivia = .newlines(2)
        
        return [DeclSyntax(funcDecl)]
    }
    
}



// MARK: - Extensions

extension SyntaxCollection {
    
    mutating func removeLast() {
        self.remove(at: self.index(before: self.endIndex))
    }
    
}
