//
//  File.swift
//  
//
//  Created by 김건우 on 6/19/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ReactorMacro { }

extension ReactorMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let classDecl = declaration.as(ClassDeclSyntax.self)
        else {
            throw CustomError.message("이 매크로는 Class에만 적용할 수 있습니다.")
        }
        
        let isNeededPublicAccessControl = classDecl.modifiers.first(where: { modifier in
            switch modifier.name.tokenKind {
            case .keyword(.public):
                return true
            default:
                return false
            }
        }) != nil
        
        var resultDecl: [DeclSyntax] = ["\(raw: isNeededPublicAccessControl ? "public" : "") var initialState: State"]
        let members = classDecl.memberBlock.members
        
        
        if case let .argumentList(arguments) = node.arguments,
           let expression = arguments.first?.expression,
           let baseName = expression.as(MemberAccessExprSyntax.self)?
            .declName.baseName,
           baseName == "NoAction" {
             
            resultDecl.append("\(raw: isNeededPublicAccessControl ? "public" : "") typealias Action = NoAction")
            
        } else {
            
            var isExistingAction = false
            var isExistingMutation = false
            var isExistingState = false
            
            if let _ = members.first(where: { member in
                if let enumDecl = member.decl.as(EnumDeclSyntax.self),
                   enumDecl.name.text == "Action" {
                    return true
                }
                return false
            }) {
                isExistingAction = true
            }
            
            if let _ = members.first(where: { member in
                if let enumDecl = member.decl.as(EnumDeclSyntax.self),
                   enumDecl.name.text == "Mutation" {
                    return true
                }
                return false
            }) {
                isExistingMutation = true
            }
            
            
            if let _ = members.first(where: { member in
                if let structDecl = member.decl.as(StructDeclSyntax.self),
                   structDecl.name.text == "State" {
                    return true
                }
                return false
            }) {
                isExistingState = true
            }
            
            if !isExistingState {
                resultDecl.append("\(raw: isNeededPublicAccessControl ? "public" : "") struct State { }")
            }
            
            if !isExistingAction || !isExistingMutation {
                resultDecl.append("\(raw: isNeededPublicAccessControl ? "public" : "") typealias Action = NoAction")
            }
            
        }

        return resultDecl
    }
    
}



extension ReactorMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let reactorExt = try ExtensionDeclSyntax("extension \(type.trimmed): Reactor { }")
        var resultDecl: [ExtensionDeclSyntax] = [reactorExt]
        
        guard
            case let .argumentList(arguments) = node.arguments,
           let expression = arguments.first?.expression,
           let baseName = expression.as(MemberAccessExprSyntax.self)?
            .declName.baseName
        else { return resultDecl }
        
        if baseName.text == "equatable" {
            let identifiableExt = try ExtensionDeclSyntax("extension \(type.trimmed): Identifiable") {
                MemberBlockItemSyntax(
                    decl: try VariableDeclSyntax("var id: UUID") {
                        "UUID()"
                    }
                )
            }
            
            let equatableExt = try ExtensionDeclSyntax("extension \(type.trimmed): Equatable") {
                MemberBlockItemSyntax(
                    decl: try FunctionDeclSyntax("static func == (lhs: \(type.trimmed), rhs: \(type.trimmed)) -> Bool") {
                        "lhs.id == rhs.id"
                    }
                )
            }
            
            resultDecl.append(contentsOf: [
                identifiableExt, equatableExt
            ])
        }
        
        return resultDecl
    }
    
}
