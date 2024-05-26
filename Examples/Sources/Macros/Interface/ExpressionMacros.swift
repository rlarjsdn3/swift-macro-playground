//
//  File.swift
//  
//
//  Created by 김건우 on 5/24/24.
//

import Foundation


// MARK: - Stringify Expression

@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(
    module: "MacrosImplementation",
    type: "StringifyMacro"
)


// MARK: - URL Expression

@freestanding(expression)
public macro URL(_ s: String) -> URL = #externalMacro(
    module: "MacrosImplementation",
    type: "URLMacro"
)


