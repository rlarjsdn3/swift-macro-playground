//
//  File.swift
//  
//
//  Created by 김건우 on 6/19/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DiscardableResultMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard
            let _ = declaration.as(ProtocolDeclSyntax.self)
        else {
            throw CustomError.message("이 매크로는 Protocol에만 적용할 수 있습니다.")
        }
        
        if let _ = member.as(FunctionDeclSyntax.self) {
            return [
                AttributeSyntax(
                    atSign: .atSignToken(),
                    attributeName: IdentifierTypeSyntax(
                        name: .identifier("discardableResult")
                    )
                )
            ]
        }
        return []
    }
    
}
