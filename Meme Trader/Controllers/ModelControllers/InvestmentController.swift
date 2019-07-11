//
//  InvestmentController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation

class InvestmentController {
    
    // MARK: - Properties
    
    static let shared = InvestmentController()
    
    let db = UserController.shared.db
    
    var investmentDic: [String: Any] = [:]
    
    // MARK: - Methods
    
    func createInvestmentFor(meme: Meme, funded: Double?, bought: Double?, completion: @escaping (Error?) -> Void) {
        
    }
    
    func closeInvestmentFor(investment: Investment, completion: @escaping (Double, Error?) -> Void) {
        
    }
    
    func fetchInvestmentsFromFirestoreFor(completion: @escaping (Error?) -> Void) {
        
    }
}
