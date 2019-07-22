//
//  Investment.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

struct Investment {
    
    var userUID: String
    var investmentUID: String
    var memeUID: String
    var date: Date
    var amountFunded: Double?
    var amountBought: Double?
    var numberOfShares: Double
    
    init?(from dictionary: [String: Any], uid: String) {
        guard let userUID = dictionary[Document.userUID] as? String,
            let memeUID = dictionary[Document.memeUID] as? String,
            let date = dictionary[Document.date] as? Timestamp,
            let amountFunded = dictionary[Document.funded] as? Double,
            let amountBought = dictionary[Document.bought] as? Double,
            let numberOfShares = dictionary[Document.numberOfShares] as? Double
            else { return nil}
        
        self.userUID = userUID
        self.investmentUID = uid
        self.memeUID = memeUID
        self.date = date.dateValue()
        self.amountFunded = amountFunded
        self.amountBought = amountBought
        self.numberOfShares = numberOfShares
    }
}
