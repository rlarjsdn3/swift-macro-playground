//
//  File.swift
//  
//
//  Created by 김건우 on 6/17/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PeerValueWithSuffixNameMacro: PeerMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let identified = declaration.asProtocol(NamedDeclSyntax.self)
        else { return [] }
        
        return ["var \(raw: identified.name.text)_peer: Int { 1 }"]
    }
    
}
