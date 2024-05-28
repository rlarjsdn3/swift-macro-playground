//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

// MARK: - Codable Complex

@attached(member, names: named(CodingKeys))
@attached(extension, conformances: Codable)
public macro Codable() = #externalMacro(
    module: "MacrosImplementation",
    type: "CodableMacro"
)

@attached(peer)
public macro CodableKey(name: String) = #externalMacro(
    module: "MacrosImplementation",
    type: "CodableKeyMacro"
)



// MARK: - Dictionary Storage Complex

@attached(memberAttribute)
@attached(member, names: named(_storage))
public macro DictionaryStorage() = #externalMacro(
    module: "MacrosImplementation",
    type: "DictionaryStorageMacro"
)

@attached(accessor)
public macro DictionaryStorageProperty() = #externalMacro(
    module: "MacrosImplementation",
    type: "DictionaryStoragePropertyMacro"
)



// MARK: - Raw Value Complex

@attached(member, names: named(init), named(rawValue))
@attached(extension, conformances: RawRepresentable)
public macro RawValue<T>(_ type: T.Type) = #externalMacro(
    module: "MacrosImplementation",
    type: "RawValueMacro"
)



