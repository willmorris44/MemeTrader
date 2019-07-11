//
//  MemeController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase

class MemeController {
    
    // MARK: - Properties
    
    static let shared = MemeController()
    
    let db = UserController.shared.db
    
    var memesDic: [String: [Meme]] = ["new":[], "hotDaily":[], "hotWeekly":[], "topDaily":[], "topWeekly":[], "topMonthly":[], "topYearly":[], "topAlltime":[]]
    
    // MARK: - Methods
    
    func createMemeWith(caption: String, picUrl: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        var ref: DocumentReference?
        ref = db.collection("memes").addDocument(data: [
            "userUID" : currentUser.uid,
            "caption" : caption,
            "picUrl" : picUrl,
            "date" : FieldValue.serverTimestamp()
            ], completion: { (error) in
                if let error = error {
                    print("There was an error creating the meme: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                } else {
                    guard let docID = ref?.documentID else { print(#function); completion(Errors.unwrapDocumentID); return }
                    
                    UserController.shared.updateUserMemesWith(meme: docID, completion: { (error) in
                        if let error = error {
                            print("There was an error updating users memes: \(error): \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                    })
                    print("Document added with ID: \(docID)")
                }
        })
        completion(nil)
    }
    
    func deleteMeme(_ meme: Meme, completion: @escaping (Error?) -> Void) {
        
    }
    
    func changeVotesfor(meme: Meme, upvoted: Bool, downvoted: Bool, completion: @escaping (Error?) -> Void) {
        if upvoted {
            db.collection("memes").document(meme.memeUID).updateData([
                "upvotes" : FieldValue.increment(1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else {
            db.collection("memes").document(meme.memeUID).updateData([
                "downvotes" : FieldValue.increment(1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        completion(nil)
    }
    
    func updateMemeCommentsWith(commentUID: String, for meme: Meme, delete: Bool, completion: @escaping (Error?) -> Void) {
        if delete {
            db.collection("memes").document(meme.memeUID).updateData([
                "comments" : FieldValue.arrayRemove([commentUID]),
                "numOfComments" : FieldValue.increment(-1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes comments: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else {
            db.collection("memes").document(meme.memeUID).updateData([
                "comments" : FieldValue.arrayUnion([commentUID]),
                "numOfComments" : FieldValue.increment(1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes comments: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        completion(nil)
    }
    
    func updateMemeSharesWith(cash: Double, for meme: Meme, completion: @escaping (Error?) -> Void) {
        let sharesBought = cash / meme.value
        db.collection("memes").document(meme.memeUID).updateData([
            "sharesBought" : FieldValue.increment(sharesBought)
        ]) { (error) in
            if let error = error {
                print("There was an error updating meme shares: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func fetchMemesFromFirestoreWith(filter: String, completion: @escaping (Error?) -> Void) {
        var results: [String]?
        if filter == "new" {
            db.collection("memes").limit(to: 50).order(by: "date", descending: true).getDocuments { (snapshot, error) in
                if let error = error {
                    print("There was an error fetching the memes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                guard let snapshot = snapshot,
                    snapshot.documents.count > 0
                    else { print(#function); completion(Errors.unwrapSnapshot); return }
                
                self.memesDic[filter] = snapshot.documents.compactMap { Meme(from: $0.data(), uid: $0.documentID) }
            }
        } else {
            FilterController.shared.initializeFilter(filter: filter) { (filter, error) in
                if let error = error {
                    print("There was an error initializing filter: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                guard let filter = filter else { return }
                results = filter
            }
            
            guard let results = results else { print(#function); completion(Errors.unwrapResults); return }
            for result in results {
                self.db.collection("memes").document(result).getDocument { (snapshot, error) in
                    if let error = error {
                        print("There was an error fetching the meme: \(error) : \(error.localizedDescription) : \(#function)")
                        completion(error)
                        return
                    }
                    
                    guard let data = snapshot?.data() else { print(#function); completion(Errors.unwrapData); return }
                    guard let docID = snapshot?.documentID else { print(#function); completion(Errors.unwrapDocumentID); return }
                    guard let meme = Meme(from: data, uid: docID) else { print(#function); completion(Errors.decodeMeme); return }
                    
                    self.memesDic[filter]?.append(meme)
                }
            }
        }
        completion(nil)
    }
}
