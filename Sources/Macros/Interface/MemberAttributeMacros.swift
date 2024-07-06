//
//  MemberAttributesMacros.swift
//
//
//  Created by 김건우 on 5/23/24.
//

// MARK: - DiscardableResult

@attached(memberAttribute)
public macro DiscardableResult() = #externalMacro(
    module: "MacrosImplementation",
    type: "DiscardableResultMacro"
)



// MARK: - Member Deprecated

@attached(memberAttribute)
public macro variableDeprecated() = #externalMacro(
    module: "MacrosImplementation",
    type: "VariableDeprecatedMacro"
)



// MARK: - Wrap Stored Properties

@attached(memberAttribute)
public macro wrapStoredProperties(_ attributeName: String) = #externalMacro(
    module: "MacrosImplementation",
    type: "WrapStoredPropertiesMacro"
)


// MARK: - Pulsing

@attached(memberAttribute)
public macro Pulsing() = #externalMacro(
    module: "MacrosImplementation",
    type: "PulsingMacro"
)
