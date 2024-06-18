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
        DependencyValueMacro.self,
        EnvironmentValueMacro.self,
        CodableMacro.self,
        CodableKeyMacro.self,
        DictionaryStorageMacro.self,
        DictionaryStoragePropertyMacro.self,
        RawValueMacro.self,
        FuncUniqueMacro.self,
        NativeFileIDMacro.self,
        NativeFilePathMacro.self,
        NativeLineMacro.self,
        NativeColumnMacro.self,
        StringifyMacro.self,
        UnwrapMacro.self,
        URLMacro.self,
        WarningMacro.self,
        DefaultFatalErrorImplementationMacro.self,
        EquatableExtensionMacro.self,
        CaseDetectionMacro.self,
        EnumSubsetMacro.self,
        MetaEnumMacro.self,
        VariableDeprecatedMacro.self,
        WrapStoredPropertiesMacro.self,
        AddAsyncMacro.self,
        AddCompletionHandlerMacro.self,
        PeerValueWithSuffixNameMacro.self
    ]
}
#endif
