//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//

import MacrosInterface

func runPeerMacrosPlayground() {
    
    
    
    // MARK: - Peer Value With Suffix Name
    
    @PeerValueWithSuffixName
    actor Counter {
        var value = 0
    }
    
    _ = Counter()
    
}
