//
//  File.swift
//  
//
//  Created by 김건우 on 7/6/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacrosImplementation

fileprivate let testMacros: [String: Macro.Type] = [
    "Pulsing": PulsingMacro.self,
    "NoPulse": NoPulseMacro.self
]

final class PulsingMacroTests: XCTestCase {
    
    func testPulsingMacro() {
        
        assertMacroExpansion(
            """
            @Pulsing
            struct State {
                var name: String
                var dayOfBirth: Date
                var age: Int
            }
            """,
            expandedSource:
            """
            struct State {
                @Pulse
                var name: String
                @Pulse
                var dayOfBirth: Date
                @Pulse
                var age: Int
            }
            """,
            macros: testMacros
        )
        
    }
    
    
    func testPulsingMacroWithNoPulse() {
        
        assertMacroExpansion(
            """
            @Pulsing
            struct State {
                var name: String
                @NoPulse var dayOfBirth: Date
                var age: Int
            }
            """,
            expandedSource:
            """
            struct State {
                @Pulse
                var name: String
                var dayOfBirth: Date
                @Pulse
                var age: Int
            }
            """,
            macros: testMacros
        )
        
    }
    
}
