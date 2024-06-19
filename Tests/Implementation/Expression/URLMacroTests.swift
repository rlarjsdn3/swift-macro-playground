//
//  File.swift
//  
//
//  Created by 김건우 on 5/24/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "URL": URLMacro.self
]

final class URLMacroTests: XCTestCase {
    
    func testURLMacro() throws {
        
        assertMacroExpansion(
            """
            #URL("https://www.apple.com/kr/")
            """,
            expandedSource: 
            """
            URL(string: "https://www.apple.com/kr/")!
            """,
            macros: testMacros)
        
    }
    
}
