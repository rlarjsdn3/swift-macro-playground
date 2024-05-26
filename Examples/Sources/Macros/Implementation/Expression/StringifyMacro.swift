//
//  File.swift
//  
//
//  Created by 김건우 on 5/26/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct StringifyMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {        
        guard 
            let argument = node.argumentList.first?.expression
        else {
            throw CustomError.message("주어진 인자가 유효하지 않습니다.")
        }

        return "(\(argument), \(literal: argument.description))"
    }
    
}
