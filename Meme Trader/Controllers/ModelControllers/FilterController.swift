//
//  FilterController.swift
//  Meme Trader
//
//  Created by Will morris on 7/10/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

class FilterController {
    
    // MARK: - Properties
    
    static let shared = FilterController()
    
    let db = UserController.shared.db
    
    // MARK: - Methods
    
    func initializeFilter(filter: String, completion: @escaping ([String]?, Error?) -> Void) {
        db.collection("filters").document(filter).getDocument { (snapshot, error) in
            if let error = error {
                print("There was an error fetching the filter: \(error) : \(error.localizedDescription) : \(#function)")
                completion(nil, error)
                return
            }
            
            guard let data = snapshot?.data() else { print(#function); completion(nil, Errors.unwrapData); return }
            let results = Filter(from: data)?.memeUIDs
            completion(results, nil)
        }
    }
}
