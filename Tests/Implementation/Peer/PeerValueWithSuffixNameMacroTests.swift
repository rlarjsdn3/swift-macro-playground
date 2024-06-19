//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "PeerValueWithSuffixName": PeerValueWithSuffixNameMacro.self
]

final class PeerValueWithSuffixNameMacroTests: XCTestCase {
    
    func testPeerValueWithSuffixNameMacro() {
        
        assertMacroExpansion(
            """
            @PeerValueWithSuffixName
            func someFunction() { }
            """,
            expandedSource:
            """
            func someFunction() { }
            
            var someFunction_peer: Int {
                1
            }
            """,
            macros: testMacros
        )
        
    }
    
}
