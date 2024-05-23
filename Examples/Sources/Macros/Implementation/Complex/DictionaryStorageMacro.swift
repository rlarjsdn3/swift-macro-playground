//
//  File.swift
//  
//
//  Created by 김건우 on 5/23/24.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

// MARK: - Dictionary Storage Macro

public struct DictionaryStorageMacro { }

extension DictionaryStorageMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return ["\n    var _storage: [String: Any] = [:]"]
    }
    
}

extension DictionaryStorageMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard 
            let property = member.as(VariableDeclSyntax.self),
            property.isStoredProperty
        else {
            return []
        }
        
        return [
            AttributeSyntax(
                leadingTrivia: [.newlines(1), .spaces(4)],
                attributeName: IdentifierTypeSyntax(
                    name: TokenSyntax.identifier("DictionaryStorageProperty")
                )
            )
        ]
                
    }
    
}



// MARK: - Dictionary Storage Property Macro

public struct DictionaryStoragePropertyMacro: AccessorMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard
            let varDecl = declaration.as(VariableDeclSyntax.self),
            let binding = varDecl.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
            binding.accessorBlock == nil,
            let type = binding.typeAnnotation?.type
        else {
            return []
        }
        
        // Ignore the "_storage" variable.
        if identifier.text == "_storage" {
            return []
        }
        
        guard let defaultValue = binding.initializer?.value else {
            throw CustomError.message("stored property must have an initalizer")
        }
        
        return [
            """
            get {
                _storage[\(literal: identifier.text), default: \(defaultValue)] as! \(type)
            }
            """,
            """
            set {
                _storage[\(literal: identifier.text)] = newValue
            }
            """
        ]
            
    }
    
}



// MARK: - Extensions

extension VariableDeclSyntax {
    
    var isStoredProperty: Bool {
        // variable should be declared only one per line
        if bindings.count != 1 {
            return false
        }
        
        let binding = bindings.first!
        switch binding.accessorBlock?.accessors {
        case .none:
            return true
            
        case let .accessors(accessors):
            for accessor in accessors {
                switch accessor.accessorSpecifier.tokenKind {
                case .keyword(.willSet), .keyword(.didSet):
                    // Observers can occur on a stored property
                    break
                    
                default:
                    // Other accessor make it a computed property
                    return false
                }
            }
            
        case .getter:
            return false
        }
        
        return true
    }
    
}
