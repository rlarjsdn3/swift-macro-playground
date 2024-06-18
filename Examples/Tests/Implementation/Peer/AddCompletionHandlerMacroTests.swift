//
//  File.swift
//  
//
//  Created by 김건우 on 6/18/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "AddCompletionHandler": AddCompletionHandlerMacro.self
]

final class AddCompletionHandlerMacroTests: XCTestCase {
    
    func testAddCompletionHandlerMacro() {
        
        assertMacroExpansion(
            """
            @AddCompletionHandler
            func f(a: Int, for b: String, _ value: Double) async -> String {
                return b
            }
            """,
            expandedSource:
            """
            func f(a: Int, for b: String, _ value: Double) async -> String {
                return b
            }

            func f(a: Int, for b: String, _ value: Double, completionHandler: @escaping (String) -> Void) {
                Task {
                    completionHandler(await f(a: a, for: b, value))
                }
            }
            """,
            macros: testMacros
        )
        
    }
    
}
