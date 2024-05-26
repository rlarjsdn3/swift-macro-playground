//
//  AccessorMacrosPlayground.swift
//  
//
//  Created by 김건우 on 5/22/24.
//

import Dependencies
import MacrosInterface
import SwiftUI

// MARK: - EnvironmentValue Accessor

private struct MyEnvironmentKey: EnvironmentKey {
    static let defaultValue: String = "Default value"
}

extension EnvironmentValues {
    @EnvironmentValue(for: MyEnvironmentKey.self)
    var myCustomValue: String
}



// MARK: - DependencyValue Accessor

private struct MyDependencyKey: DependencyKey {
    static let liveValue: String = "Default Value"
}

extension DependencyValues {
    @DependencyValue(for: MyDependencyKey.self)
    var myCustomValue: String
}

func runEnvironmentValueAccessorMacroPlayground() {
    var environmentValues = EnvironmentValues()
    print("Default myEnvironmentValue: \(environmentValues.myCustomValue)")
    environmentValues.myCustomValue = "New Value"
    print("New myEnvironmentValue: \(environmentValues.myCustomValue)")
    
//    @Dependency(\.myCustomValue) var myCustomValue: String
    var dependencyValues = DependencyValues()
    print("Default myDependcyValue: \(dependencyValues.myCustomValue)")
    dependencyValues.myCustomValue = "New Value"
    print("New myDependencyValue: \(dependencyValues.myCustomValue)")
}







