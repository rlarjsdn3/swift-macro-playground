//
//  File.swift
//  
//
//  Created by 김건우 on 5/28/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "RawRepresentable": RawRepresentableMacro.self
]

final class RawRepresentableMacroTests: XCTestCase {
    
    func testRawValueMacro() throws {
        
        assertMacroExpansion(
            """
            @RawRepresentable(Int.self)
            public struct Test {

            }
            """,
            expandedSource:
            """
            public struct Test {
            
                public var rawValue: Int
            
                public init?(rawValue: Int) {
                    self.rawValue = rawValue
                }
            
            }
            
            extension Test: RawRepresentable {
            }
            """,
            macros: testMacros
        )
        
    }
    
}
