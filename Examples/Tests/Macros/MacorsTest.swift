import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MacrosInterface)
import MacrosInterface
import MacrosImplementation

let testMacros: [String: Macro.Type] = [
    "EnumSubset": EnumSubsetMacro.self,
]
#endif

final class MacrosTest: XCTestCase {
    
    func testEnumSubsetMacro() throws {
        #if canImport(MacrosInterface)
        assertMacroExpansion(
            """
            @EnumSubset<Slope>
            enum EasySlope {
                case beginnerParadise
                case practiceRun
            }
            """,
            expandedSource: """
            enum EasySlope {
                case beginnerParadise
                case practiceRun
            
                init?(_ slope: Slope) {
                    switch slope {
                    case .beginnerParadise:
                        self = .beginnerParadise
                    case .practiceRun:
                        self = .practiceRun
                    default:
                        return nil
                    }
                }
            
                var value: Slope {
                    switch self {
                        case .beginnerParadise:
                            return .beginnerParadise
                        case .practiceRun:
                            return .practiceRun
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

}
