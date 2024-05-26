//
//  MemberAttributesMacros.swift
//
//
//  Created by 김건우 on 5/23/24.
//

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
