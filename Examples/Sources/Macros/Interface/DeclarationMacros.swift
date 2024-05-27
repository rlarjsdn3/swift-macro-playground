//
//  File.swift
//  
//
//  Created by 김건우 on 5/27/24.
//

// MARK: - Func Unique Declaration

@freestanding(declaration, names: named(MyClass))
public macro FuncUnique() = #externalMacro(
    module: "MacrosImplementation",
    type: "FuncUniqueMacro"
)
