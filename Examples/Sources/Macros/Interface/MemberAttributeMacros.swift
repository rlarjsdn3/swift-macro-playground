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
