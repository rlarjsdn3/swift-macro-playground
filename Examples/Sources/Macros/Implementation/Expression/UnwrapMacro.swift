//
//  File.swift
//  
//
//  Created by 김건우 on 5/29/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UnwrapMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let arguments = node.argumentList
        let captureVar = context.makeUniqueName("unique")
        
        guard
            let originWrapped = arguments.first?.expression,
            let message = arguments.last?.expression
        else {
            throw CustomError.message("")
        }
                
        return """
        { [\(captureVar) = \(originWrapped)] in
            \(makeGuardStmt(wrapped: captureVar, originalWrapped: originWrapped, message: message, in: context))
            \(makeReturnStmt(wrapped: captureVar))
        }()
        """
    }
    
    public static func makeGuardStmt(
        wrapped: TokenSyntax,
        originalWrapped: ExprSyntax,
        message: ExprSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        let messagePrefix = "Unexpectedly found nil: ‘\(originalWrapped.description)’"
//        let originalLoc = context.location(of: originalWrapped)!
        
        return """
            guard let \(wrapped) else {
                preconditionFailure(\(literal: messagePrefix) + \(message))
            }
        """
    }
    
    public static func makeReturnStmt(wrapped: TokenSyntax) -> ExprSyntax {
        return """
        return \(wrapped)
        """
    }
    
}
