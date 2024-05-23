//
//  MemberMacro.swift
//
//
//  Created by 김건우 on 5/23/24.
//

// MARK: - Case Detection Member

@attached(member, names: arbitrary)
public macro CaseDetection() = #externalMacro(
    module: "MacrosImplementation",
    type: "CaseDetectionMacro"
)


// MARK: - Enum Subset Member

@attached(member, names: named(init))
public macro EnumSubset<Superset>() = #externalMacro(
    module: "MacrosImplementation",
    type: "EnumSubsetMacro"
)
