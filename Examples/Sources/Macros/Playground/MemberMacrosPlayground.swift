//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import Foundation
import MacrosInterface

func runMemberMacrosPlayground() {
    
    // MARK: - Case Detection
    
    @CaseDetection
    enum Pet {
        case dog
        case cat(curious: Bool)
        case parrot
        case snake
    }
    
    let pet: Pet = .cat(curious: true)
    print("Pet is dog: \(pet.isDog)")
    print("Pet is cat: \(pet.isCat)")
    
    
    
    // MARK: - Codable
}
