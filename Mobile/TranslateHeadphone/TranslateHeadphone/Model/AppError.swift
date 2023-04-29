//
//  AppError.swift
//  PrettyWidget (iOS)
//
//  Created by Tuan Phan Quoc on 12/03/2022.
//

import Foundation

enum AppError: Error, Equatable {
    case connection
    case http
    case data
    case custom(text: String)
    case unkown
    case session
    case none
    
    var text: String {
        switch self {
        case .connection:
            return "network_error"
        case .http:
            return "network_error"
        case .data:
            return "unkown_error"
        case .custom(let text):
            return text
        case .unkown:
            return "unkown_error"
        case .none:
            return ""
        case .session:
            return "session_expired"
        }
    }
}
