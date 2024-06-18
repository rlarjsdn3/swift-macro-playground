//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//

import MacrosInterface

func runPeerMacrosPlayground() {
    
    // MARK: Add Async
    
    struct MyStruct {
      @AddAsync
      func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
        completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
      }

      @AddAsync
      func d(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Bool) -> Void) -> Void {
        completionBlock(true)
      }
    }
    
    
    
    // MARK: - Peer Value With Suffix Name
    
    @PeerValueWithSuffixName
    actor Counter {
        var value = 0
    }
    
    _ = Counter()
    
}
