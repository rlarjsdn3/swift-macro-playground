//
//  File.swift
//  
//
//  Created by 김건우 on 5/26/24.
//

import Foundation
import MacrosInterface

import DIContainer

func runExpressionMacrosPlayground() {
    
    // MARK: - Source Location Expression
    
    print("FileID: \(#FileID as String)")
    print("FilePath: \(#FilePath as String)")
    print("Line: \(#Line as Int)")
    print("Column: \(#Column as Int)")
    
    
    // MARK: - Stringify Expression
    
    let a = #stringify(2 + 3)
    print("Stringify: ", a)
    
    
    // MARK: - Unwrap Expression
    
    let optionalValue: Int? = 32
    let value = #unwrap(optionalValue, message: "옵셔널 해제 실패")
    print("Unwrap Optional Value: ", value)
    
    
    // MARK: - URL Expression
    
    let url: URL = #URL("https://www.apple.com/kr")
    print("Froce Wrapped Url: \(url)")
    
    
    // MARK: - Warning Expression
    
    #myWarning("remember to pass a string literal here")
    
    
    // MARK: - Todo Expression
    
    #todo("리팩토링된 UserDefaults로 Data 불러오기")
    
    
    // MARK: - Register Expression
    
    class ViewModel {
        func sayHello() { print("Hello, Macro!") }
    }
    
    #register(ViewModel.self, key: "Key") { _ in
        ViewModel()
    }
    
    
    // MARK: - Resolve Expression
    let viewModel = try? #resolve(ViewModel.self)
    viewModel?.sayHello()
    
}
