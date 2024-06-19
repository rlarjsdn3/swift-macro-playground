//
//  File.swift
//  
//
//  Created by 김건우 on 6/19/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "todo": TodoMacro.self
]

final class TodoMacroTests: XCTestCase {
    
    func testTodoMacro() {
        
        assertMacroExpansion(
            """
            #todo("코드 리팩토링하기")
            """,
            expandedSource:
            """
            ()
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "TODO: - 코드 리팩토링하기",
                    line: 1,
                    column: 1,
                    severity: .warning
                )
            ],
            macros: testMacros
        )
        
    }
    
}
