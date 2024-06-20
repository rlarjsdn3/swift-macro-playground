//
//  File.swift
//  
//
//  Created by 김건우 on 6/20/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RegisterMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let closureExpr = node.trailingClosure
        else {
            throw CustomError.message("이 매크로에 유효한 클로저를 전달해야 합니다.")
        }
        
        var parameters: [String] = []
        
        if let metaType = node.argumentList
            .first?.expression {
            parameters.append("type: \(metaType.description)")
        }
        
        if let expression = node.argumentList.last?.expression,
           let segments = expression
            .as(StringLiteralExprSyntax.self)?.segments,
           segments.count == 1,
           case let .stringSegment(key) = segments.first {
            parameters.append("key: \"\(key.content.text)\"")
        }
           
        
        return """
        Container.standard.register(\(raw: parameters.joined(separator: ", "))) \(closureExpr)
        """
    }
    
}
