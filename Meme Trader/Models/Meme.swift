//
//  Meme.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase

struct Meme {
    
    var userUID: String
    var memeUID: String
    var caption: String
    var picUrl: String
    var image: UIImage?
    var date: Date
    var upvotes: Double
    var downvotes: Double
    var rateOfVotes: Double
    var comments: [String]
    var numOfComments: Double
    var sharesBought: Double
    var value: Double
    
    init?(from dictionary: [String: Any], uid: String) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let caption = dictionary[Document.caption] as? String,
            let picUrl = dictionary[Document.picUrl] as? String,
            let date = dictionary[Document.date] as? Timestamp,
            let upvotes = dictionary[Document.upvotes] as? Double,
            let downvotes = dictionary[Document.downvotes] as? Double,
            let rateOfVotes = dictionary[Document.rateOfVotes] as? Double,
            let comments = dictionary[Document.comments] as? [String],
            let numOfComments = dictionary[Document.numOfComments] as? Double,
            let sharesBought = dictionary[Document.sharesBought] as? Double,
            let value = dictionary[Document.value] as? Double
            else { return nil}
        
        self.userUID = userUID
        self.memeUID = uid
        self.caption = caption
        self.picUrl = picUrl
        self.date = date.dateValue()
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.rateOfVotes = rateOfVotes
        self.comments = comments
        self.numOfComments = numOfComments
        self.sharesBought = sharesBought
        self.value = value
    }
}
