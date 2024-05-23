//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

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
