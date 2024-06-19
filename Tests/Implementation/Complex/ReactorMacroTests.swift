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
    "Reactor": ReactorMacro.self
]

final class ReactorMacroTests: XCTestCase {
    
    func testReactorMacro() {
        
        assertMacroExpansion(
            """
            @Reactor
            class TestReactor {
                enum Action { }
                enum Mutation { }
                init() { self.initalState = State() }
            }
            """,
            expandedSource:
            """
            class TestReactor {
                enum Action { }
                enum Mutation { }
                init() { self.initalState = State() }
            
                var initialState: State
            
                struct State {
                }
            }
            
            extension TestReactor: Reactor {
            }
            """,
            macros: testMacros
        )
        
    }
    
    func testReactorNoActionMacro() {
        
        assertMacroExpansion(
            """
            @Reactor(.noAction)
            class TestReactor {
                struct State { }
                init() { self.initialState = State() }
            }
            """,
            expandedSource:
            """
            class TestReactor {
                struct State { }
                init() { self.initialState = State() }

                var initialState: State

                typealias Action = NoAction
            }

            extension TestReactor: Reactor {
            }
            """,
            macros: testMacros
        )
        
    }
    
    func testReactorEquatableMacro() {
        
        assertMacroExpansion(
            """
            @Reactor(.equatable)
            class TestReactor {
                init() { self.initalState = State() }
            }
            """,
            expandedSource:
            """
            class TestReactor {
                init() { self.initalState = State() }

                var initialState: State

                struct State {
                }

                typealias Action = NoAction
            }

            extension TestReactor: Reactor {
            }

            extension TestReactor: Identifiable {
                var id: UUID {
                    UUID()
                }
            }

            extension TestReactor: Equatable {
                static func == (lhs: TestReactor, rhs: TestReactor) -> Bool {
                    lhs.id == rhs.id
                }
            }
            """,
            macros: testMacros
        )
        
    }
    
}
