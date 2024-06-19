//
//  File.swift
//  
//
//  Created by 김건우 on 5/29/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "unwrap": UnwrapMacro.self
]

final class UnwrapMacroTests: XCTestCase {
    
    func testUnwrapMacro() throws {
        
        assertMacroExpansion(
        """
        let optionalValue: Int? = 32
        let value = #unwrap(optionalValue, message: "옵셔널 해제 실패")
        """,
        expandedSource:
        """
        let optionalValue: Int? = 32
        let value = { [__macro_local_6uniquefMu_ = optionalValue] in
                guard let __macro_local_6uniquefMu_ else {
                    preconditionFailure("Unexpectedly found nil: ‘optionalValue’" + "옵셔널 해제 실패")
                }
            return __macro_local_6uniquefMu_
        }()
        """,
        macros: testMacros,
        testFileName: "UnwrapMacroTests.swift"
        )
        
        
        
    }
    
}
