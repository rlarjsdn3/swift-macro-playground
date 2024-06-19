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


// MARK: - Source Location Macro

@freestanding(expression)
public macro FileID<T: ExpressibleByStringLiteral>() -> T = #externalMacro(
    module: "MacrosImplementation",
    type: "NativeFileIDMacro"
)


@freestanding(expression)
public macro FilePath<T: ExpressibleByStringLiteral>() -> T = #externalMacro(
    module: "MacrosImplementation",
    type: "NativeFilePathMacro"
)


@freestanding(expression)
public macro Line<T: ExpressibleByIntegerLiteral>() -> T = #externalMacro(
    module: "MacrosImplementation",
    type: "NativeLineMacro"
)


@freestanding(expression)
public macro Column<T: ExpressibleByIntegerLiteral>() -> T = #externalMacro(
    module: "MacrosImplementation",
    type: "NativeColumnMacro"
)


// MARK: - Warning Macro

@freestanding(expression)
public macro myWarning(_ message: String) = #externalMacro(
    module: "MacrosImplementation",
    type: "WarningMacro"
)
