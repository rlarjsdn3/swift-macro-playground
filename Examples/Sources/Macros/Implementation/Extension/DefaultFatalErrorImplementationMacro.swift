//
//  File.swift
//  
//
//  Created by 김건우 on 5/27/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DefaultFatalErrorImplementationMacro: ExtensionMacro {
    
    private static let messageID = MessageID(
        domain: "MacroExamples",
        id: "ProtocolDefaultImplmentation"
    )
    
    public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingExtensionsOf type: some TypeSyntaxProtocol,
      conformingTo protocols: [TypeSyntax],
      in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else {
            throw SimpleDiagnostic(
                message: "Macro `defaultFatalErrorImplmentation` can only be applied to a protocol",
                diagnosticID: messageID,
                severity: .error
            )
        }
        
        let methods = protocolDecl.memberBlock.members
            .map(\.decl)
            .compactMap { decl -> FunctionDeclSyntax? in
                guard
                    var funcDecl = decl.as(FunctionDeclSyntax.self)
                else {
                    return nil
                }
                funcDecl.body = CodeBlockSyntax {
                    ExprSyntax(#"fatalError("whoops 😅")"#)
                }
                return funcDecl
            }
        
        if methods.isEmpty {
            return []
        }
        
        let extensionDecl = ExtensionDeclSyntax(extendedType: type) {
            for method in methods {
                MemberBlockItemSyntax(decl: method)
            }
            
            MemberBlockItemList
        }
        
        return [extensionDecl]
    }
    
}

