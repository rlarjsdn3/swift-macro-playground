//
//  File.swift
//  
//
//  Created by 김건우 on 6/11/24.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MetaEnumMacro {
    
    // MARK: - Properties
    let parentTypeName: TokenSyntax
    let parentParamName: TokenSyntax
    let childCases: [EnumCaseElementSyntax]
    let access: DeclModifierListSyntax.Element?
    
    let emptyModifier = DeclModifierSyntax(name: .identifier(""))
    
    // MARK: - Intializer
    init(
        node: AttributeSyntax,
        declaration: some DeclGroupSyntax,
        context: some MacroExpansionContext
    ) throws {
        guard
            let enumDecl = declaration.as(EnumDeclSyntax.self)
        else {
            throw DiagnosticsError(diagnostics: [
                CaseMacroDiagnostic.notAnEnum(declaration)
                    .diagnose(at: Syntax(node))
            ])
        }
        
        parentTypeName = enumDecl.name.with(\.trailingTrivia, [])
        
        access = enumDecl.modifiers.first(where: { modifier in
            switch modifier.name.tokenKind {
            case .keyword(.public): return true
            default: return false
            }
        })
        
        childCases = enumDecl.caseElements.map { parentCase in
            parentCase.with(\.parameterClause, nil)
        }
        
        parentParamName = context.makeUniqueName("parent")
    }
    
    // MARK: - Helpers
    
    func makeMetaEnum() -> DeclSyntax {
        let caseDecls = childCases
            .map { childCase in
                "    case \(childCase.name)"
            }
            .joined(separator: "\n")
        
        return """
            \(access ?? emptyModifier)enum Meta {
            \(raw: caseDecls)
            \(makeMetaInit())
        }
        """
    }
    
    func makeMetaInit() -> DeclSyntax {
        let caseStatements = childCases
            .map { childCase in
                """
                case .\(childCase.name):
                    self = .\(childCase.name)
                """
            }
            .joined(separator: "\n")

        return """
        \(access ?? emptyModifier)init(_ \(parentParamName): \(parentTypeName)) {
            switch \(parentParamName) {
                \(raw: caseStatements)
            }
        }
        """
    }
    
}

// MARK: - Member Macro

extension MetaEnumMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let macro = try MetaEnumMacro(
            node: node,
            declaration: declaration,
            context: context
        )
        
        return [macro.makeMetaEnum()]
    }
    
}



// MARK: - Diagnostic

enum CaseMacroDiagnostic {
    case notAnEnum(DeclGroupSyntax)
}

extension CaseMacroDiagnostic: DiagnosticMessage {
    
    var message: String {
        switch self {
        case let .notAnEnum(decl):
            return "'@MetaEnum' can only be attached to an enum not \(decl.descriptiveDeclKind(withArticle: true))"
        }
    }
    
    var diagnosticID: SwiftDiagnostics.MessageID {
        switch self {
        case .notAnEnum:
            return MessageID(
                domain: "MetaEnumDiagnostic",
                id: "notAnEnum"
            )
        }
    }
    
    var severity: SwiftDiagnostics.DiagnosticSeverity {
        switch self {
        case .notAnEnum:
            return .error
        }
    }
    
    func diagnose(at node: Syntax) -> Diagnostic {
        Diagnostic(node: node, message: self)
    }
    
    
}



// MARK: - Extensions

extension EnumDeclSyntax {
    
    var caseElements: [EnumCaseElementSyntax] {
        memberBlock.members.flatMap { member in
            guard
                let caseDecl = member.decl.as(EnumCaseDeclSyntax.self)
            else { return [EnumCaseElementSyntax]() }
            return [EnumCaseElementSyntax](caseDecl.elements)
        }
    }
    
}

extension DeclGroupSyntax {
    
    func descriptiveDeclKind(withArticle article: Bool = false) -> String {
        switch self {
        case is ActorDeclSyntax:
            return article ? "an actor" : "actor"
        case is ClassDeclSyntax:
            return article ? "a class" : "class"
        case is ExtensionDeclSyntax:
            return article ? "an extension" : "extension"
        case is ProtocolDeclSyntax:
            return article ? "a protocol" : "protocol"
        case is StructDeclSyntax:
            return article ? "a struct" : "struct"
        case is EnumDeclSyntax:
            return article ? "an enum" : "enum"
        default:
            fatalError("Unknown DeclGroupSyntax")
        }
    }
    
}
