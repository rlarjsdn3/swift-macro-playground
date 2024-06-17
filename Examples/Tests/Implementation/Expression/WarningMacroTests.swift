//
//  File.swift
//  
//
//  Created by 김건우 on 6/11/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "myWarning": WarningMacro.self
]

final class WarningMacroTests: XCTestCase {
    
    func testWarningMacro() throws {
        
        assertMacroExpansion(
            """
            #myWarning("This is a warning")
            """,
            expandedSource:
            """
            ()
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "This is a warning",
                    line: 1,
                    column: 1,
                    severity: .warning
                )
            ],
            macros: testMacros
        )
        
    }
    
}
