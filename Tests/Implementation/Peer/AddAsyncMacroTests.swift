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

fileprivate var testMacros: [String: Macro.Type] = [
    "AddAsync": AddAsyncMacro.self
]

final class AddAsyncMacroTests: XCTestCase {
    
    func testAddAsyncMacro() {
        
        assertMacroExpansion(
            #"""
            @AddAsync
            func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
                completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
            }
            """#,
            expandedSource:
            #"""
            func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
                completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
            }

            func c(a: Int, for b: String, _ value: Double) async throws -> String  {
                try await withCheckedThrowingContinuation { continuation in
                    c(a: a, for: b, value) { returnValue in
            
                        switch returnValue {
                            case let .success(value):
                                continuation.resume(returning: value)
                            case let .failure(error):
                                continuation.resume(throwing: error)
                        }
                    }
                }
            }
            """#,
            macros: testMacros
        )
        
    }
    
}
