//
//  ErrorCase.swift
//  Notino
//
//  Created by Henrich Mauritz on 06/03/2022.
//

import Foundation

public enum ErrorCase: Error {
    case invalidURL
    case coreDataIdNotFound
}

extension ErrorCase: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL.", comment: "")
            
        case .coreDataIdNotFound:
            return NSLocalizedString("ID was not found in Core Data database.", comment: "")
        }
    }
}
