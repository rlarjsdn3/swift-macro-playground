//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct VariableDeprecatedMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard
            let _ = member.as(VariableDeclSyntax.self)
        else { return [] }

        return ["@available(*, deprecated)"]
    }
    
}
