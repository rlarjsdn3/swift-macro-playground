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
    "wrapStoredProperties": WrapStoredPropertiesMacro.self
]

final class WrapStoredPropertiesMacroTests: XCTestCase {
    
    func testWrapStoredPropertiesMacro() throws {
        
        assertMacroExpansion(
            """
            @wrapStoredProperties("Published")
            struct OldStorage {
                var x: Int
            }
            """,
            expandedSource:
            """
            struct OldStorage {
                @Published
                var x: Int
            }
            """,
            macros: testMacros
        )
        
    }
    
    func testMacroExpansionComputedProperty() throws {
        
        assertMacroExpansion(
            """
            @wrapStoredProperties("Published")
            struct Test {
                var value: Int { 10 }
            }
            """,
            expandedSource:
            """
            struct Test {
                var value: Int { 10 }
            }
            """,
            macros: testMacros
        )
        
    }
    
}
