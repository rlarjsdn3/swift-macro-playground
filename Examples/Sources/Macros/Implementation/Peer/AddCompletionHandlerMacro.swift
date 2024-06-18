//
//  File.swift
//  
//
//  Created by 김건우 on 6/18/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AddCompletionHandlerMacro: PeerMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // Only on functions at the moment
        guard
            var funcDecl = declaration.as(FunctionDeclSyntax.self)
        else {
            throw CustomError.message("@addCompletionHandler only works on functions")
        }
        
        // This only makes sense for async functions.
        if funcDecl.signature.effectSpecifiers?.asyncSpecifier == nil {
            var newEffects: FunctionEffectSpecifiersSyntax
            if let existingEffects = funcDecl.signature.effectSpecifiers {
                newEffects = existingEffects
                newEffects.asyncSpecifier = .keyword(.async, trailingTrivia: .space)
            } else {
                newEffects = FunctionEffectSpecifiersSyntax(
                    asyncSpecifier: .keyword(.async, trailingTrivia: .space)
                )
            }
            
            var newSignature = funcDecl.signature
            newSignature.effectSpecifiers = newEffects
            let messageID = MessageID(
                domain: "AddCompletionHandlerMacro",
                id: "AddCompletionHandler"
            )
            
            let diag = Diagnostic(
                node: Syntax(funcDecl.funcKeyword),
                message: SimpleDiagnostic(
                    message: "can only add a completion-handler variant to an 'async' function",
                    diagnosticID: messageID,
                    severity: .error
                ),
                fixIts: [
                    FixIt(
                        message: SimpleDiagnostic(
                            message: "add 'async'",
                            diagnosticID: messageID,
                            severity: .error
                        ),
                        changes: [
                            FixIt.Change.replace(
                                oldNode: Syntax(funcDecl.signature),
                                newNode: Syntax(newSignature)
                            )
                        ]
                    )
                ]
            )
            
            context.diagnose(diag)
            return []
        }
        
        // Form the completion handler paramter
        var resultType = funcDecl.signature.returnClause?.type
        resultType?.leadingTrivia = []
        resultType?.trailingTrivia = []
        
        let completionHandlerParam = FunctionParameterSyntax(
            firstName: .identifier("completionHandler"),
            colon: .colonToken(trailingTrivia: .space),
            type: "@escaping (\(resultType ?? "")) -> Void" as TypeSyntax
        )
        
        // Add the completion handler parameter to the paramter list
        let parameterList = funcDecl.signature.parameterClause.parameters
        var newParameterList = parameterList
        if var lastParam = parameterList.last {
            // We need to add a trailing comma to the preceding list
            newParameterList.removeLast()
            lastParam.trailingComma = .commaToken(trailingTrivia: .space)
            newParameterList += [
                lastParam,
                completionHandlerParam
            ]
        } else {
            newParameterList.append(completionHandlerParam)
        }
        
        let callArguments: [String] = parameterList.map { parameter in
            let argName = parameter.secondName ?? parameter.firstName
            
            let paramName = parameter.firstName
            if paramName.text != "_" {
                return "\(paramName.text): \(argName.text)"
            }
            
            return "\(argName.text)"
        }
        
        let callBody: ExprSyntax =
        """
        \(funcDecl.name)(\(raw: callArguments.joined(separator: ", ")))
        """
        
        let newBody: ExprSyntax =
        """
        Task { completionHandler(await \(callBody)) }
        """
        
        // Drop the @addCompletionHandler attriute from the new declaration
        let newAttributeList = funcDecl.attributes.filter { attribute in
            let attributeType = attribute
                .as(AttributeSyntax.self)?
                .attributeName
                .as(IdentifierTypeSyntax.self)
            let nodeType = node
                .as(AttributeSyntax.self)?
                .attributeName
                .as(IdentifierTypeSyntax.self)
            
            return attributeType?.name.text != nodeType?.name.text
        }
        
        // drop async
        funcDecl.signature.effectSpecifiers?.asyncSpecifier = nil
        
        // drop result type
        funcDecl.signature.returnClause = nil
        
        // add completion handler parameter
        funcDecl.signature.parameterClause.parameters = newParameterList
        funcDecl.signature.parameterClause.trailingTrivia = []
        
        funcDecl.body = CodeBlockSyntax(
            leftBrace: .leftBraceToken(),
            statements: CodeBlockItemListSyntax {
                CodeBlockItemSyntax(item: .expr(newBody))
            },
            rightBrace: .rightBraceToken(leadingTrivia: .newline)
        )
        
        funcDecl.attributes = newAttributeList
        funcDecl.leadingTrivia = .newlines(2)
        
        return [DeclSyntax(funcDecl)]
    }
    
}
