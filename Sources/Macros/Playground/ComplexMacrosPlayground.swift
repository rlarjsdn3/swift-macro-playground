//
//  File.swift
//  
//
//  Created by 김건우 on 5/24/24.
//

import Foundation
import MacrosInterface

import ReactorKit

// MARK: - Dictionary Storage

@DictionaryStorage
struct Point {
    var x: Int = 1
    var y: Int = 2
}



// MARK: - Codable

@Codable
struct Member {
    var name: String
    @CodableKey(name: "day_of_birth") var dayOfBirth: String
    var age: Int
}


// MARK: - RawValue

@RawRepresentable(Int.self)
struct Key { }


// MARK: - Reactor

@Reactor(.noAction)
class SomeReactor {
    struct State { }
    
    init() { self.initialState = State() }
}



func runDictionaryStorageMacroPlayground() {
    
    var point = Point()
    print("Point storage begins as an empty dictionary: \(point)")
    print("Default value for point.x: \(point.x)")
    point.y = 17
    print("Point storage contains only the value we set: \(point)")
    print("Point storage _storage Value: \(point._storage)")
    
    
    let jsonString = "{\"name\":\"김소월\", \"day_of_birth\":\"1998-03-21\", \"age\":27,}"
    if let jsonData = jsonString.data(using: .utf8),
       let decodedMember = try? JSONDecoder().decode(Member.self, from: jsonData) {
        print("Decoded Member: \(decodedMember)")
    } else {
      print("Json Decoding Fail..")
    }
    
    
    let key = Key(rawValue: 10 )
    print("Key-rawValue: \(String(describing: key?.rawValue))")
    
}




