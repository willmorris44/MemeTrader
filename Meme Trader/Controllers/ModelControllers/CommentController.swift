//
//  CommentController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

class CommentController {
    
    // MARK: - Properties
    
    static let shared = CommentController()
    
    let db = UserController.shared.db
    
    var commentsDic: [String: Any] = ["meme":[], "user":[]]
    
    // MARK: - Methods
    
    func createCommentFor(meme: Meme, text: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        var ref: DocumentReference?
        ref = db.collection("comments").addDocument(data: [
            "userUID" : currentUser.uid,
            "memeUID" : meme.memeUID,
            "date" : FieldValue.serverTimestamp(),
            "text" : text
            ], completion: { (error) in
                if let error = error {
                    print("There was an error creating comment: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                } else {
                    guard let docID = ref?.documentID else { print(#function); completion(Errors.unwrapDocumentID); return }
                    
                    UserController.shared.updateUserCommentsWith(comment: docID, completion: { (error) in
                        if let error = error {
                            print("There was an error updating user comments: \(error) : \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                    })
                    
                    MemeController.shared.updateMemeCommentsWith(commentUID: docID, for: meme, delete: false, completion: { (error) in
                        if let error = error {
                            print("There was an error updating meme comments: \(error) : \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                    })
                }
        })
    }
    
    func updateCommentVotesFor(comment: Comment, upvoted: Bool, downvoted: Bool, completion: @escaping (Error?) -> Void) {
        if upvoted {
            db.collection("comments").document(comment.commentUID).updateData([
                "votes" : FieldValue.increment(1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else {
            db.collection("comments").document(comment.commentUID).updateData([
                "votes" : FieldValue.increment(-1.0)
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
    
    func deleteComment(_ comment: Comment, completion: @escaping (Error?) -> Void) {
        
    }
    
    func fetchCommentsFromFirestoreFor(meme: Meme?, completion: @escaping (Error?) -> Void) {
        if let meme = meme {
            db.collection("comments").whereField("memeUID", isEqualTo: meme.memeUID).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print("There was an error fetching meme comments: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                guard let snapshot = snapshot,
                    snapshot.documents.count > 0
                    else { print(#function); completion(Errors.unwrapSnapshot); return }
                
                self.commentsDic["meme"] = snapshot.documents.compactMap { Comment(from: $0.data(), uid: $0.documentID) }
            })
        } else {
            guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
            
            db.collection("comments").whereField("userUID", isEqualTo: currentUser.uid).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print("There was an error fetching user comments: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                guard let snapshot = snapshot,
                    snapshot.documents.count > 0
                    else { print(#function); completion(Errors.unwrapSnapshot); return }
                
                self.commentsDic["user"] = snapshot.documents.compactMap { Comment(from: $0.data(), uid: $0.documentID) }
            })
        }
        completion(nil)
    }
}
