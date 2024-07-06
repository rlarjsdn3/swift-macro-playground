//
//  File.swift
//  
//
//  Created by 김건우 on 7/6/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PulsingMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        
        guard
            let structDecl = declaration.as(StructDeclSyntax.self),
            structDecl.name.trimmed.text == "State"
        else {
            throw CustomError.message("이 매크로는 State 구조체에만 적용할 수 있습니다.")
        }
        
        guard
            let varDecl = member.as(VariableDeclSyntax.self)
        else { return [] }
        
        if let _ = varDecl.attributes.first(where: { attribute in
            attribute
                .as(AttributeSyntax.self)?
                .attributeName
                .as(IdentifierTypeSyntax.self)?
                .name.trimmed.text == "NoPulse"
        }) {
            return []
        }
        
        if !varDecl.isStoredProperty {
            return []
        }
        
        return [
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(
                    name: "Pulse"
                )
            )
        ]
    }
    
}


// MARK: - Extensions

fileprivate extension VariableDeclSyntax {
    
    var isStoredProperty: Bool {
        if bindings.count != 1 {
            return false
        }
        
        let binding = bindings.first
        switch binding?.accessorBlock?.accessors {
        case .none:
            break
            
        case .accessors(let accessors):
            for accessor in accessors {
                switch accessor.accessorSpecifier.tokenKind {
                case .keyword(.didSet), .keyword(.willSet):
                    break
                    
                default:
                    return false
                }
            }
            
        case .getter:
            return false
        }
        
        return true
    }
    
}
