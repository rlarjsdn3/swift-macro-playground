//
//  ExtensionMacrosPlayground.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import MacrosInterface

// MARK: - Default Fatal Error Implementation

@defaultFatalErrorImplementation
protocol API {
    func getItems() -> [String]
    func removeItem(id: String)
}

struct MyAPI: API { }

// MARK: - Eqautable Extension

@equatable
struct Pet {
    let name: String
}

func runEquatableExtensionMacroPlayground() {
    let myAPI = MyAPI()
//    myAPI.getItems()
    print("Implementation of `API` protocol with default implementation: \(myAPI)")
    
    
    let cat = Pet(name: "Tom")
    let mouse = Pet(name: "Jerry")
    
    print("Has the cat \(cat) the same name as the mouse \(mouse)?", cat == mouse ? "Yes." : "No.")
}
