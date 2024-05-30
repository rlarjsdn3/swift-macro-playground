//
//  File.swift
//  
//
//  Created by 김건우 on 5/26/24.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "DependencyValue": DependencyValueMacro.self
]

final class DependencyValueMacroTests: XCTestCase {
    
    func testDendencyValue() throws {
        
        assertMacroExpansion(
            """
            extension DependencyValues {
                @DependencyValue(for: WeatherClientKey.self)
                var weatherClient: WeatherClient
            }
            """,
            expandedSource:
            """
            extension DependencyValues {
                var weatherClient: WeatherClient {
                    get {
                        self [WeatherClientKey.self]
                    }
                    set {
                        self [WeatherClientKey.self] = newValue
                    }
                }
            }
            """,
            macros: testMacros
        )
        
    }
    
}
