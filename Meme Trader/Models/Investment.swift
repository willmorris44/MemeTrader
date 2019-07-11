//
//  Investment.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation

struct Investment {
    
    var userUID: String
    var investmentUID: String
    var memeUID: String
    var date: Date
    var amountFunded: Double?
    var amountBought: Double?
    var numberOfShares: Double
}
