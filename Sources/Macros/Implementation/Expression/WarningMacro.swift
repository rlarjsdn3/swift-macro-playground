//
//  File.swift
//  
//
//  Created by 김건우 on 6/11/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct WarningMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let firstArgument = node.argumentList.first,
            let stringLiteral = firstArgument.expression
                .as(StringLiteralExprSyntax.self),
            stringLiteral.segments.count == 1,
            case let .stringSegment(message) = stringLiteral.segments.first
        else {
            throw CustomError.message("이 매크로의 인자로 문자열 리터럴을 넘겨야 합니다.")
        }
        
        context.diagnose(
            Diagnostic(
                node: node,
                message: SimpleDiagnostic(
                    message: message.content.description,
                    diagnosticID: MessageID(
                        domain: "test123",
                        id: "error"
                    ),
                    severity: .warning
                )
            )
        )
        
        return "()"
    }
    
}
