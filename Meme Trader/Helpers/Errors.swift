//
//  Errors.swift
//  Meme Trader
//
//  Created by Will morris on 7/10/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation

enum Errors: Error {
    
    case noCurrentUser
    case unwrapData
    case unwrapDocumentID
    case unwrapResults
    case unwrapSnapshot
    case decodeMeme
}

extension Errors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noCurrentUser:
            return NSLocalizedString("No current user", comment: "")
        case .unwrapData:
            return NSLocalizedString("Couldnt unwrap data", comment: "")
        case .unwrapDocumentID:
            return NSLocalizedString("Couldn't unwrap ref.documentID", comment: "")
        case .unwrapResults:
            return NSLocalizedString("Couldn't unwrap results array", comment: "")
        case .unwrapSnapshot:
            return NSLocalizedString("Couldn't unwrap snapshot", comment: "")
        case .decodeMeme:
            return NSLocalizedString("Couldn't decode data into meme", comment: "")
        }
    }
}
