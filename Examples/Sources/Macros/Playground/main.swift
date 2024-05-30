//
//  main.swift
//
//
//  Created by 김건우 on 5/22/24.
//

import Foundation
import MacrosInterface

import SwiftParser
#if swift(>=6)
internal import SwiftSyntax
#else
import SwiftSyntax
#endif

let sourceText =
"""
let url = URL(string: "https://www.apple.com/kr")!
"""

// Parse the source code in sourceText into a syntax tree
let sourceFile: SourceFileSyntax = Parser.parse(source: sourceText)

// The "description" of the source tree is the source-accurate view of what was parsed.
assert(sourceFile.description == sourceText)

// Visualize the complete syntax tree.
dump(sourceFile)


// MARK: - Accessor Macros

runEnvironmentValueAccessorMacroPlayground()



// MARK: - Complex Macros

runDictionaryStorageMacroPlayground()



// MARK: - Declaration Macros

runDeclarationMacroPlayground()



// MARK: - Expression Macro

runExpressionMacrosPlayground()




// MARK: - Extension Macros

runEquatableExtensionMacroPlayground()



// MARK: - Member Attrubute Macros

runMemberAttributeMacrosPlayground()



// MARK: - Member Macros

runMemberMacrosPlayground()




