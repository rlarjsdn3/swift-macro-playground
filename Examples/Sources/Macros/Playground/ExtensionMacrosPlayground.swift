//
//  ExtensionMacrosPlayground.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import MacrosInterface

// MARK: - Eqautable Extension

@equatable
struct Pet {
    let name: String
}

func runEquatableExtensionMacroPlayground() {
    let cat = Pet(name: "Tom")
    let mouse = Pet(name: "Jerry")
    
    print("Has the cat \(cat) the same name as the mouse \(mouse)?", cat == mouse ? "Yes." : "No.")
}
