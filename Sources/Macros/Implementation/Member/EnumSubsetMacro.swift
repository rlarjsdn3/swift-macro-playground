//
//  EnumSubsetMacro.swift
//
//
//  Created by 김건우 on 5/23/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct EnumSubsetMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let enumDecl = declaration.as(EnumDeclSyntax.self)
        else {
            throw EnumSubsetError.onlyApplicableToEnum
        }
        
        guard
            let supersetType = node.attributeName
                .as(IdentifierTypeSyntax.self)?
                .genericArgumentClause?
                .arguments.first?
                .argument
        else { 
            throw EnumSubsetError.invalidSupersetType
        }
        
        let members = enumDecl.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecls.flatMap { $0.elements }
        
        let initializer = try InitializerDeclSyntax("init?(_ slope: \(supersetType))") {
            try SwitchExprSyntax("switch slope") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case .\(element.name):
                            self = .\(element.name)
                        """
                    )
                }
                SwitchCaseSyntax("default: return nil")
            }
        }
        
        let variable = try VariableDeclSyntax("var value: \(supersetType)") {
            try SwitchExprSyntax("switch self") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case .\(element.name):
                            return .\(element.name)
                        """
                    )
                }
            }
        }
        
        return [
            DeclSyntax(initializer),
            DeclSyntax(variable)
        ]
    }
    
    
}


// MARK: - Error

enum EnumSubsetError: Error, CustomStringConvertible {
    
    case invalidSupersetType
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .invalidSupersetType: return "제네릭 파라미터 타입이 유효하지 않습니다."
        case .onlyApplicableToEnum: return "@EnumSubset은 Enum에만 적용될 수 있습니다."
        }
    }
}
