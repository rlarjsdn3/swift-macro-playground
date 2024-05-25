//
//  File.swift
//  
//
//  Created by 김건우 on 5/22/24.
//

#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        EnvironmentValueMacro.self,
        CodableMacro.self,
        CodableKeyMacro.self,
        DictionaryStorageMacro.self,
        DictionaryStoragePropertyMacro.self,
        URLMacro.self,
        EquatableExtensionMacro.self,
        CaseDetectionMacro.self,
        EnumSubsetMacro.self,
        VariableDeprecatedMacro.self
    ]
}
#endif
