//
//  User.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var userUID: String
    var tag: String
    var name: String
    var bio: String
    var picUrl: String
    var date: Date
    var cash: Double
    var portfolioValue: Double
    var networth: Double
    var investments: [String]
    var memes: [String]
    var comments: [String]
    var memesUpvoted: [String]
    var memesDownvoted: [String]
    var commentsUpvoted: [String]
    var commentsDownvoted: [String]
    
    init?(from dictionary: [String: Any], uid: String) {
        guard let tag = dictionary[Document.tag] as? String,
            let name = dictionary[Document.name] as? String,
            let bio = dictionary[Document.bio] as? String,
            let picUrl = dictionary[Document.picUrl] as? String,
            let date = dictionary[Document.date] as? Timestamp,
            let cash = dictionary[Document.cash] as? Double,
            let portfolioValue = dictionary[Document.portfolioValue] as? Double,
            let networth = dictionary[Document.networth] as? Double,
            let investments = dictionary[Document.investments] as? [String],
            let memes = dictionary[Document.memes] as? [String],
            let comments = dictionary[Document.comments] as? [String],
            let memesUpvoted = dictionary[Document.memesUpvoted] as? [String],
            let memesDownvoted = dictionary[Document.memesDownvoted] as? [String],
            let commentsUpvoted = dictionary[Document.commentsUpvoted] as? [String],
            let commentsDownvoted = dictionary[Document.commentsDownvoted] as? [String]
            else { return nil }
        
        self.userUID = uid
        self.tag = tag
        self.name = name
        self.bio = bio
        self.picUrl = picUrl
        self.date = date.dateValue()
        self.cash = cash
        self.portfolioValue = portfolioValue
        self.networth = networth
        self.investments = investments
        self.memes = memes
        self.comments = comments
        self.memesUpvoted = memesUpvoted
        self.memesDownvoted = memesDownvoted
        self.commentsUpvoted = commentsUpvoted
        self.commentsDownvoted = commentsDownvoted
    }
}

