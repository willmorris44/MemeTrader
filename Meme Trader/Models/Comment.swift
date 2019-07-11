//
//  Comment.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    
    var userUID: String
    var commentUID: String
    var memeUID: String
    var date: Date
    var text: String
    var votes: Double
    
    init?(from dictionary: [String: Any], uid: String) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let memeUID = dictionary[Document.memeUID] as? String,
            let date = dictionary[Document.date] as? Timestamp,
            let text = dictionary[Document.text] as? String,
            let votes = dictionary[Document.votes] as? Double
            else { return nil }
        
        self.userUID = userUID
        self.commentUID = uid
        self.memeUID = memeUID
        self.date = date.dateValue()
        self.text = text
        self.votes = votes
    }
}
