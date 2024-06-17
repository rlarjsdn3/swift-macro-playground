//
//  File.swift
//  
//
//  Created by 김건우 on 6/11/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct NativeFileIDMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        return context.location(
            of: node,
            at: .afterLeadingTrivia,
            filePathMode: .fileID
        )!.file
    }
    
}


public struct NativeFilePathMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        return context.location(
            of: node,
            at: .afterLeadingTrivia,
            filePathMode: .filePath
        )!.file
    }
    
}


public struct NativeLineMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        return context.location(of: node)!.line
    }
    
}


public struct NativeColumnMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        return context.location(of: node)!.column
    }
    
}
