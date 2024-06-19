//
//  File.swift
//  
//
//  Created by 김건우 on 6/19/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TodoMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let expression = node.argumentList.first?
                .expression
                .as(StringLiteralExprSyntax.self),
            expression.segments.count == 1,
            case let .stringSegment(message) = expression.segments.first
        else {
            throw CustomError.message("유효한 문자열 리터럴을 전달해야 합니다.")
        }
        
        let messageId = MessageID(domain: "TodoMacro", id: "Todo")
        
        context.diagnose(
            Diagnostic(
                node: node,
                message: SimpleDiagnostic(
                    message: "TODO: - \(message.content.text)",
                    diagnosticID: messageId,
                    severity: .warning
                )
            )
        )
        
        return "()"
    }
    
}
