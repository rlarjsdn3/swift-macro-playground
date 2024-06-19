//
//  ExtensionMacros.swift
//
//
//  Created by 김건우 on 5/23/24.
//

// MARK: - Equtable Extension

@attached(extension, conformances: Equatable)
public macro equatable() = #externalMacro(
    module: "MacrosImplementation",
    type: "EquatableExtensionMacro"
)


// MARK: - Default Fatal Error Implementation

@attached(extension, names: arbitrary)
public macro defaultFatalErrorImplementation() = #externalMacro(
    module: "MacrosImplementation",
    type: "DefaultFatalErrorImplementationMacro"
)
