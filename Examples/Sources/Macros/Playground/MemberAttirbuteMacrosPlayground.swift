//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import Foundation
import SwiftUI
import MacrosInterface

func runMemberAttributeMacrosPlayground() {
    
    // MARK: - Member Deprecated
    
    @variableDeprecated
    struct SomeStruct {
        typealias MacroName = String
        
        var oldProperty: Int = 420
        
        func oldMethod() {
            print("This is an old method.")
        }
    }
    
    let someStruct = SomeStruct()
    
    _ = SomeStruct.MacroName("name")
    _ = someStruct.oldProperty
    someStruct.oldMethod()
    
    
    
    // MARK: - Wrap Stored Properties
    
    @wrapStoredProperties("Published")
    class ViewModel: ObservableObject {
        var x: Int = 10
    }
    
    _ = ViewModel().x
    
}
