//
//  AccessorMacrosPlayground.swift
//  
//
//  Created by 김건우 on 5/22/24.
//

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

func runEnvironmentValueAccessorMacroPlayground() {
    var environmentValues = EnvironmentValues()
    print("Default myCustomValue: \(environmentValues.myCustomValue)")
    environmentValues.myCustomValue = "New Value"
    print("New myCustomValue: \(environmentValues.myCustomValue)")
}





