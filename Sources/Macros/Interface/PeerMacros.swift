//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//

// MARK: - Add Async Peer

@attached(peer, names: overloaded)
public macro AddAsync() = #externalMacro(
    module: "MacrosImplementation",
    type: "AddAsyncMacro"
)


// MARK: - Add Completion Handler Peer

@attached(peer, names: overloaded)
public macro AddCompletionHandler() = #externalMacro(
    module: "MacrosImplementation",
    type: "AddCompletionHandlerMacro"
)



// MARK: - Peer Value With Suffix Name Peer

@attached(peer, names: suffixed(_peer))
public macro PeerValueWithSuffixName() = #externalMacro(
    module: "MacrosImplementation",
    type: "PeerValueWithSuffixNameMacro"
)



// MARK: - NoPulse Peer

@attached(peer)
public macro NoPulse() = #externalMacro(
    module: "MacrosImplementation",
    type: "NoPulseMacro"
)
