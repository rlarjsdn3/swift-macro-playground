//
//  File.swift
//  
//
//  Created by 김건우 on 6/20/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ResolveMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        var parameters: [String] = []
        
        if let type = node.argumentList
            .first?.expression {
            parameters.append("type: \(type.description)")
        }
        
        if let expression = node.argumentList.last?.expression,
           let segments = expression
            .as(StringLiteralExprSyntax.self)?.segments,
           segments.count == 1,
           case let .stringSegment(key) = segments.first {
            parameters.append("key: \"\(key.content.text)\"")
        }
        
        return """
        Container.standard.resolve(\(raw: parameters.joined(separator: ", ")))
        """
    }
    
}
