//
//  Filter.swift
//  Meme Trader
//
//  Created by Will morris on 7/10/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation

struct Filter {
    
    var name: String
    var memeUIDs: [String]
    
    init?(from dictionary: [String: Any]) {
        guard let name = dictionary[Document.name] as? String,
            let memeUIDs = dictionary["memeUIDs"] as? [String]
            else { return nil }
        
        self.name = name
        self.memeUIDs = memeUIDs
    }
    
}
