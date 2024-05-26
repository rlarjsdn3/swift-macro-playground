//
//  AccessorMacro.swift
//
//
//  Created by 김건우 on 5/22/24.
//

// MARK: - DependencyValue Accessor

#if canImport(Dependencies)

import Dependencies

@attached(accessor)
public macro DependencyValue(for key: any DependencyKey.Type) = #externalMacro(
    module: "MacrosImplementation",
    type: "DependencyValueMacro"
)

#endif



#if canImport(SwiftUI)

import SwiftUI

// MARK: - EnvironmentValue Accessor

/// Add getter / setter to an attached environment value with specified EnvironementKey
@attached(accessor)
public macro EnvironmentValue(for key: any EnvironmentKey.Type) = #externalMacro(
    module: "MacrosImplementation",
    type: "EnvironmentValueMacro"
)

#endif
