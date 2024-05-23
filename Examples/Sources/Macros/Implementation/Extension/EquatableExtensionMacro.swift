//
//  EquatableExtensionMacro.swift
//
//
//  Created by 김건우 on 5/23/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct EquatableExtensionMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let equtableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Equatable {}")
        
        return [equtableExtension]
    }
    
}
