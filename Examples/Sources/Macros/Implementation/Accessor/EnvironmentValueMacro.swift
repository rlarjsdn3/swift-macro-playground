//
//  EnvironmentValueMacro.swift
//
//
//  Created by 김건우 on 5/22/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct EnvironmentValueMacro: AccessorMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            case let .argumentList(arguments) = node.arguments,
            let argument = arguments.first
        else { return [] }
        
        return [
            """
            get { self[\(argument.expression)] }
            """,
            """
            set { self[\(argument.expression)] = newValue }
            """
        ]
    }
    
}
