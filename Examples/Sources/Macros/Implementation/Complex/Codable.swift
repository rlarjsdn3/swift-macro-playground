//
//  File.swift
//  
//
//  Created by 김건우 on 5/25/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros



// MARK: - Codable Macro

public struct CodableMacro { }

extension CodableMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let structDecl = declaration.as(StructDeclSyntax.self)
        else {
            throw CustomError.message("해당 매크로는 Struct에만 적용할 수 있습니다.")
        }
        
        let memberList = structDecl.memberBlock.members
        
        let cases = memberList.compactMap { member -> String? in
            guard
                let propertyName = member.decl
                    .as(VariableDeclSyntax.self)?
                    .bindings.first?
                    .pattern
                    .as(IdentifierPatternSyntax.self)?
                    .identifier
                    .text
            else {
                return nil
            }
            
            if let codableKey = member.decl
                .as(VariableDeclSyntax.self)?
                .attributes
                .first(where: { element in
                    element
                        .as(AttributeSyntax.self)?
                        .attributeName
                        .as(IdentifierTypeSyntax.self)?
                        .description
                    == "CodableKey"
                }),
               let keyValue = codableKey
                .as(AttributeSyntax.self)?
                .arguments?
                .as(LabeledExprListSyntax.self)?
                .first?
                .expression
                
            {
                return "case \(propertyName) = \(keyValue)"
            } else {
                return "case \(propertyName)"
            }
        }
            
        return [
            """
            enum CodingKeys: String, CodingKey {
                \(raw: cases.joined(separator: "\n"))
            }
            """
        ]
    }
    
}

extension CodableMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let codableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Codable { }")
        
        return [codableExtension]
    }
    
}



// MARK: - CodableKey Macro

public struct CodableKeyMacro: PeerMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return []
    }
    
}
