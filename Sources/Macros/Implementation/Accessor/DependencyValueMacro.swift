//
//  File.swift
//  
//
//  Created by 김건우 on 5/26/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DependencyValueMacro: AccessorMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            case let .argumentList(arguments) = node.arguments,
            let expression = arguments.first?.expression
        else {
            return []
        }
        
        return [
            """
            get { self[\(expression)] }
            """,
            """
            set { self[\(expression)] = newValue }
            """
        ]
    }
    
}
