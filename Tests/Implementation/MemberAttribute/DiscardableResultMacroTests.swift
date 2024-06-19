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
    "DiscardableResult": DiscardableResultMacro.self
]

final class DiscardableResultMacroTests: XCTestCase {
    
    func testDiscardableResultMacro() {
        
        assertMacroExpansion(
            """
            @DiscardableResult
            protocol MessageService {
                func sendMessage(to: String) -> Message
            }
            """,
            expandedSource:
            """
            protocol MessageService {
                @discardableResult
                func sendMessage(to: String) -> Message
            }
            """,
            macros: testMacros
        )
        
    }
    
}
