//
//  File.swift
//  
//
//  Created by 김건우 on 5/22/24.
//

import SwiftDiagnostics
import SwiftSyntax

struct SimpleDiagnostic: DiagnosticMessage, Error {
    let message: String
    let diagnosticID: MessageID
    let severity: DiagnosticSeverity
}

extension SimpleDiagnostic: FixItMessage {
    var fixItID: MessageID { diagnosticID }
}

enum CustomError: Error, CustomStringConvertible {
    case message(String)
    
    var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
    
}
