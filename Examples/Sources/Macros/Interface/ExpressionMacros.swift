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


// MARK: - Unwrap Expression

@freestanding(expression)
public macro unwrap<T>(_ value: T?, message: String) -> T = #externalMacro(
    module: "MacrosImplementation",
    type: "UnwrapMacro"
)


// MARK: - URL Expression

@freestanding(expression)
public macro URL(_ s: String) -> URL = #externalMacro(
    module: "MacrosImplementation",
    type: "URLMacro"
)


