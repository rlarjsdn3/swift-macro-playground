//
//  File.swift
//  
//
//  Created by 김건우 on 5/26/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros



public struct WrapStoredPropertiesMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard
            let property = member.as(VariableDeclSyntax.self),
            property.isStoredProperty
        else {
            return []
        }
        
        guard
            case let .argumentList(arguments) = node.arguments,
            let stringLiteral = arguments
                .first?
                .expression
                .as(StringLiteralExprSyntax.self),
            stringLiteral.segments.count == 1,
            case let .stringSegment(wrapperName) = stringLiteral.segments.first
        else {
            throw CustomError.message("문자열 리터럴이 유효하지 않습니다.")
        }
        
        return [
            AttributeSyntax(
                leadingTrivia: [.newlines(1), .spaces(4)],
                attributeName: IdentifierTypeSyntax(
                    name: TokenSyntax(stringLiteral: wrapperName.content.text)
                )
            )
        ]
    }
    
}



// MARK: - Extensions

extension VariableDeclSyntax {
    
    fileprivate var isStoredProperty: Bool {
        // variable should be declared only one per lien
        if bindings.count != 1 {
            return false
        }
        
        let binding = bindings.first!
        switch binding.accessorBlock?.accessors {
        case .none:
            return true
            
        case let .accessors(accessors):
            for accessor in accessors {
                switch accessor.accessorSpecifier.tokenKind {
                case .keyword(.willSet), .keyword(.didSet):
                    // Observers can occur on a stored property
                    break
                    
                default:
                    // Other accessors make it a computed property
                    return false
                }
            }
            
            return true
            
        case .getter:
            return false
        }
    }
    
}


extension DeclGroupSyntax {
    
    func storedProperties() -> [VariableDeclSyntax] {
        return memberBlock.members.compactMap { member in
            guard
                let variable = member.decl.as(VariableDeclSyntax.self),
                variable.isStoredProperty
            else {
                return nil
            }
            
            return variable
        }
    }
    
}
