//
//  File.swift
//  
//
//  Created by 김건우 on 5/26/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self
]

final class StringifyMacroTests: XCTestCase {
    
    func testStringifyMacro() throws {
        
        assertMacroExpansion(
            """
            let a = #stringify(x + y)
            """,
            expandedSource:
            """
            let a = (x + y, "x + y")
            """,
            macros: testMacros
        )
        
    }
    
}


