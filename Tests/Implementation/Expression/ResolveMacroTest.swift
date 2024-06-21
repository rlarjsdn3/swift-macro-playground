//
//  File.swift
//  
//
//  Created by 김건우 on 6/20/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "resolve": ResolveMacro.self
]

final class ResolveMacroTest: XCTestCase {
    
    func testResolveMacroTest() {
        
        assertMacroExpansion(
            """
            let vm = try? #resolve(ViewModel.self)
            """,
            expandedSource:
            """
            let vm = try? Container.standard.resolve(type: ViewModel.self)
            """,
            macros: testMacros
        )
        
    }
    
    func testResolveWithKeyMacroTest() {
        
        assertMacroExpansion(
            """
            let vm = try? #resolve(ViewModel.self, key: "vm")
            """,
            expandedSource:
            """
            let vm = try? Container.standard.resolve(type: ViewModel.self, key: "vm")
            """,
            macros: testMacros
        )
        
    }
    
}
