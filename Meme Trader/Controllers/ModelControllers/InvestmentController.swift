//
//  InvestmentController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

class InvestmentController {
    
    // MARK: - Properties
    
    static let shared = InvestmentController()
    
    let db = UserController.shared.db
    
    var investmentArr: [Investment] = []
    
    // MARK: - Methods
    
    func createInvestmentFor(meme: Meme, funded: Double?, bought: Double?, shares: Int?, completion: @escaping (Error?) -> Void) {
        guard let user = UserController.currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        var ref: DocumentReference?
        ref = db.collection("investments").addDocument(data: [
            "userUID" : user.userUID,
            "memeUID" : meme.memeUID,
            "date" : FieldValue.serverTimestamp(),
            "amountFunded" : funded ?? 0,
            "amountBought" : bought ?? 0,
            "numberOfShares" : shares ?? 0
        ]) { (error) in
            if let error = error {
                print("There was an error creating investment: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
            
            guard let docID = ref?.documentID else { print(#function); completion(Errors.unwrapDocumentID); return }
            
            UserController.shared.updateUserInvestmentsWith(investment: docID, delete: false, completion: { (error) in
                if let error = error {
                    print("There was an error updating users investments: \(error): \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                if let bought = bought {
                    UserController.shared.updateUserMoneyWith(cash: -bought, portfolioValue: bought, networth: -bought, completion: { (error) in
                        if let error = error {
                            print("Error updating cash: \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                    })
                }
            })
            print("Document added with ID: \(docID)")
            
            guard let shares = shares else { completion(Errors.unwrapData); return }
            MemeController.shared.updateMemeSharesWith(shares: shares, for: meme, completion: { (error) in
                if let error = error {
                    print("There was an error updating meme shares: \(error): \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                completion(nil)
                return
            })
        }
    }
    
    func closeInvestmentFor(investment: Investment, completion: @escaping (Error?) -> Void) {
        db.collection("memes").document(investment.memeUID).getDocument { (snapshot, error) in
            if let error = error {
                print("There was an error getting meme: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
            
            guard let snapshot = snapshot else { print(#function); completion(Errors.unwrapSnapshot); return }
            guard let data = snapshot.data() else { print(#function); completion(Errors.unwrapData); return }
            guard let meme = Meme(from: data, uid: snapshot.documentID) else { print(#function); completion(Errors.decodeMeme); return }
            
            let roi = investment.numberOfShares * meme.value
            
            UserController.shared.updateUserMoneyWith(cash: roi, portfolioValue: -roi, networth: roi, completion: { (error) in
                if let error = error {
                    print("There was an error updating user money: \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                UserController.shared.updateUserInvestmentsWith(investment: investment.investmentUID, delete: true, completion: {
                    (error) in
                    if let error = error {
                        print("There was an error updating users investments: \(error): \(error.localizedDescription) : \(#function)")
                        completion(error)
                        return
                    }
                    
                    MemeController.shared.updateMemeSharesWith(shares: Int(-investment.numberOfShares), for: meme, completion: { (error) in
                        if let error = error {
                            print("There was an error updating meme shares: \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                        
                        completion(nil)
                        return
                    })
                })
            })
        }
    }
    
    func fetchInvestmentsFromFirestoreFor(completion: @escaping (Error?) -> Void) {
        guard let user = UserController.currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("investments").whereField("userUID", isEqualTo: user.userUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error getting user investments: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
            
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.unwrapSnapshot); return }
            
            let investments = snapshot.documents.compactMap { Investment(from: $0.data(), uid: $0.documentID)}
            
            self.investmentArr = investments
            completion(nil)
            return
        }
    }
}
