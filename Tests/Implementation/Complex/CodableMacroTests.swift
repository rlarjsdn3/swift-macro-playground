//
//  File.swift
//  
//
//  Created by 김건우 on 5/25/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "Codable": CodableMacro.self,
    "CodableKey": CodableKeyMacro.self
]

final class CodableMacroTests: XCTestCase {
    
    func testsCodableMacro() throws {
        
        assertMacroExpansion(
            """
            @Codable
            struct Person {
                var name: String
            }
            """,
            expandedSource:
            """
            struct Person {
                var name: String
            
                enum CodingKeys: String, CodingKey {
                    case name
                }
            }
            
            extension Person: Codable {
            }
            """,
            macros: testMacros
        )
        
    }
    
    func testCodableKeyMacro() throws {
        
        assertMacroExpansion(
            """
            @Codable
            public struct Person {
                var name: String
                @CodableKey(name: "day_of_birth") var dayOfBirth: String
            }
            """,
            expandedSource:
            """
            public struct Person {
                var name: String
                var dayOfBirth: String
            
                enum CodingKeys: String, CodingKey {
                    case name
                    case dayOfBirth = "day_of_birth"
                }
            }
            
            extension Person: Codable {
            }
            """,
            macros: testMacros
        )
        
    }
    
}
