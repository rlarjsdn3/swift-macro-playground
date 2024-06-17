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
    "MetaEnum": MetaEnumMacro.self
]

final class MetaEnumMacroTests: XCTest {
    
    func testMetaEnumMacro() {
        
        assertMacroExpansion(
            """
            @MetaEnum enum Cell {
                case integer(Int)
                case text(String)
                case boolean(Bool)
                case null
            }
            """,
            expandedSource:
            """
            enum Cell {
                case integer(Int)
                case text(String)
                case boolean(Bool)
                case null

                enum Meta {
                    case integer
                    case text
                    case boolean
                    case null
                        init(_ __macro_local_6parentfMu_: Cell) {
                        switch __macro_local_6parentfMu_ {
                        case .integer:
                            self = .integer
                        case .text:
                            self = .text
                        case .boolean:
                            self = .boolean
                        case .null:
                            self = .null
                        }
                    }
                }
            }
            """,
            macros: testMacros
        )
        
    }
    
}
