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
    "register": RegisterMacro.self
]

final class RegisterMacroTests: XCTestCase {
    
    func testRegisterMacro() {
        
        assertMacroExpansion(
            """
            #register(HomeUseCaseProtocol.self) { _ in
                HomeUseCase()
            }
            """,
            expandedSource:
            """
            Container.standard.register(type: HomeUseCaseProtocol.self) { _ in
                HomeUseCase()
            }
            """,
            macros: testMacros
        )
        
    }
    
    func testRegisterWithKeyMacro() {
        
        assertMacroExpansion(
            """
            #register(HomeUseCaseProtocol.self, key: "Home") { _ in
                HomeUseCase()
            }
            """,
            expandedSource:
            """
            Container.standard.register(type: HomeUseCaseProtocol.self, key: "Home") { _ in
                HomeUseCase()
            }
            """,
            macros: testMacros
        )
        
    }
    
}
