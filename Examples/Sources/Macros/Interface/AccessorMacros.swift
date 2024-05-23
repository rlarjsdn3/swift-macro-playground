//
//  AccessorMacro.swift
//
//
//  Created by 김건우 on 5/22/24.
//

#if canImport(SwiftUI)

import SwiftUI

// MARK: - EnvironmentValue Accessor

/// Add getter / setter to an attached environment value with specified EnvironementKey
@attached(accessor)
public macro EnvironmentValue(for key: any EnvironmentKey.Type) =
    #externalMacro(module: "MacrosImplementation", type: "EnvironmentValueMacro")

#endif
