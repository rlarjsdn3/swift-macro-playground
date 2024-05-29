//
//  File.swift
//  
//
//  Created by 김건우 on 5/28/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RawValueMacro { }

extension RawValueMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let _ = declaration.as(StructDeclSyntax.self)
        else {
            throw CustomError.message("해당 매크로는 Struct에만 적용할 수 있습니다.")
        }
        
        guard
            case let .argumentList(arguments) = node.arguments,
            let type = arguments.first?
                .expression
                .as(MemberAccessExprSyntax.self)?
                .base
        else { return [] }
        
        let scope: DeclModifierSyntax = {
            declaration.modifiers
                .first(where: { modifier in
                    modifier.name.tokenKind == .keyword(.public)
                })
            ?? DeclModifierSyntax(name: .identifier(""))
        }()
        
        
        let varDecl = VariableDeclSyntax(
            modifiers: DeclModifierListSyntax(
                arrayLiteral: scope
            ),
            bindingSpecifier: .keyword(.var),
            bindings: PatternBindingListSyntax(
                arrayLiteral: PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(
                        identifier: .identifier("rawValue")
                    ),
                    typeAnnotation: TypeAnnotationSyntax(
                        type: IdentifierTypeSyntax(
                            name: .identifier(type.description)
                        )
                    )
                )
            )
        )
        
        let initDecl = InitializerDeclSyntax(
            modifiers: DeclModifierListSyntax(
                arrayLiteral: scope
            ),
            initKeyword: .identifier("init?"),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax(
                        arrayLiteral: FunctionParameterSyntax(
                            firstName: .identifier("rawValue"),
                            type: IdentifierTypeSyntax(
                                name: .identifier(type.description)
                            )
                        )
                    )
                )
            ),
            body: CodeBlockSyntax(
                statements: CodeBlockItemListSyntax(
                    arrayLiteral: CodeBlockItemSyntax(
                        item: .expr(
                            ExprSyntax(
                                InfixOperatorExprSyntax(
                                    leftOperand: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(
                                            baseName: .identifier("self")
                                        ),
                                        period: .periodToken(),
                                        declName: DeclReferenceExprSyntax(
                                            baseName: .identifier("rawValue")
                                        )
                                    ),
                                    operator: AssignmentExprSyntax(
                                        equal: .equalToken()
                                    ),
                                    rightOperand: DeclReferenceExprSyntax(baseName: .identifier("rawValue"))
                                )
                            )
                        )
                    )
                )
            )
        )

        return [
            DeclSyntax(varDecl),
            DeclSyntax(initDecl)
        ]
        
        
        
        
        // - Easier Code
        
        /*
        return [
            """
            \(scope) var rawValue: \(type.trimmed)
            """,
            """
            \(scope) init?(rawValue: \(type.trimmed)) {
                self.rawValue = rawValue
            }
            """
        ]
        */
    }
    
}

extension RawValueMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let rawRepresentableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): RawRepresentable { }")
        
        return [rawRepresentableExtension]
    }
    
}

