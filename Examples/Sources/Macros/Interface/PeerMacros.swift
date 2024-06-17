//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//



// MARK: - Peer Value With Suffix Name Peer

@attached(peer, names: suffixed(_peer))
public macro PeerValueWithSuffixName() = #externalMacro(
    module: "MacrosImplementation",
    type: "PeerValueWithSuffixNameMacro"
)
