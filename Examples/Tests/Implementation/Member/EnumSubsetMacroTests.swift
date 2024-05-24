import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacrosImplementation
import XCTest

fileprivate let testMacros: [String: Macro.Type] = [
    "EnumSubset": EnumSubsetMacro.self,
]

final class EnumSubsetMacroTests: XCTestCase {
    
    func testEnumSubsetMacro() throws {
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
    }

}
