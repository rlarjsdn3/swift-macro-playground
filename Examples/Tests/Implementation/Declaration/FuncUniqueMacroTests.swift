//
//  File.swift
//  
//
//  Created by 김건우 on 5/27/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "FuncUnique": FuncUniqueMacro.self
]

final class FuncUniqueMacroTests: XCTestCase {
    
    func testFuncUniqueMacro() throws {
        
        assertMacroExpansion(
            """
            #FuncUnique
            """,
            expandedSource:
            """
            class MyClass {
                func __macro_local_6uniquefMu_() {
                }
            }
            """,
            macros: testMacros
        )
        
    }
    
}
