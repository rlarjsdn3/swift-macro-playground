//
//  File.swift
//  
//
//  Created by 김건우 on 5/24/24.
//

import MacrosInterface

// MARK: - Dictionary Storage

@DictionaryStorage
struct Point {
    var x: Int = 1
    var y: Int = 2
}

func runDictionaryStorageMacroPlayground() {
    var point = Point()
    print("Point storage begins as an empty dictionary: \(point)")
    print("Default value for point.x: \(point.x)")
    point.y = 17
    print("Point storage contains only the value we set: \(point)")
}
