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
    "RawValue": RawValueMacro.self
]

final class RawValueMacroTests: XCTestCase {
    
    func testRawValueMacro() throws {
        
        assertMacroExpansion(
            """
            @RawValue(Int.self)
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
