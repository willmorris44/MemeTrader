//
//  DateHelper.swift
//  Meme Trader
//
//  Created by Will morris on 7/23/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation

extension Date {
    
    func collectionDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy '-' hh:mm a"
        return formatter.string(from: self)
    }
}
