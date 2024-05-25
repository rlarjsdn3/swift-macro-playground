//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public struct CaseDetectionMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let enumDecl = declaration.as(EnumDeclSyntax.self)
        else {
            throw CustomError.message("해당 매크로는 Enum에만 적용할 수 있습니다.")
        }
        
        return enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }
            .map { $0.name }
            .map { ($0, $0.initialUppercased) }
            .map { original, uppercased in
                """
                var is\(raw: uppercased): Bool {
                    if case .\(raw: original) = self {
                        return true
                    }
                    return false
                }
                """
            }
    }
    
}

extension TokenSyntax {
    fileprivate var initialUppercased: String {
        let name = self.text
        guard let initial = name.first else {
            return name
        }
        return "\(initial.uppercased())\(name.dropFirst())"
    }
}
