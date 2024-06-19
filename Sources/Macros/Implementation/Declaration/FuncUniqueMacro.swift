//
//  File.swift
//  
//
//  Created by 김건우 on 5/27/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FuncUniqueMacro: DeclarationMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let name = context.makeUniqueName("unique")
        return [
            """
            class MyClass {
                func \(name)() { }
            }
            """
        ]
    }
    
}

