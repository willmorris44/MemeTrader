//
//  UserController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    // MARK: - Properties
    
    static let shared = UserController()
    
    lazy var db = Firestore.firestore()
    
    // MARK: - Methods
    
    func createUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("There was an error creating the user: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
            
            guard let data = data else { print(#function); completion(Errors.unwrapData); return }
            self.db.collection("users").document(data.user.uid).setData([
                "date" : FieldValue.serverTimestamp()
                ], completion: { (error) in
                    if let error = error {
                        print("There was an error creating user document: \(error) : \(error.localizedDescription) : \(#function)")
                        completion(error)
                        return
                    } else {
                        print("Document added with ID: \(data.user.uid)")
                    }
            })
            completion(nil)
        }
    }
    
    func deleteUser(_ user: User, completion: @escaping (Error?) -> Void) {
        
    }
    
    func updateUserInfoWith(tag: String, name: String, bio: String, picUrl: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("users").document(currentUser.uid).setData([
            "tag" : tag,
            "name" : name,
            "bio" : bio,
            "picUrl" : picUrl,
        ]) { (error) in
            if let error = error {
                print("There was an error adding user info: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func updateUserCommentsWith(comment: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("users").document(currentUser.uid).updateData([
            "comments" : FieldValue.arrayUnion([comment])
        ]) { (error) in
            if let error = error {
                print("There was an error updating user comments: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func updateUserMemesWith(meme: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("users").document(currentUser.uid).updateData([
            "memes" : FieldValue.arrayUnion([meme])
        ]) { (error) in
            if let error = error {
                print("There was an error updating user memes: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func updateUserInvestmentsWith(investment: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("users").document(currentUser.uid).updateData([
            "investments" : FieldValue.arrayUnion([investment])
        ]) { (error) in
            if let error = error {
                print("There was an error updating user investments: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func updateUserMoneyWith(cash: Double, portfolioValue: Double, networth: Double, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("users").document(currentUser.uid).updateData([
            "cash" : cash,
            "portfolio" : portfolioValue,
            "networth" : networth
        ]) { (error) in
            if let error = error {
                print("There was an error updating user money: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func updateUserMemeVotesWith(meme: Meme, upvoted: Bool, downvoted: Bool, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        if upvoted {
            db.collection("users").document(currentUser.uid).updateData([
                "memesUpvoted" : FieldValue.arrayUnion([meme.memeUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating user votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else {
            db.collection("users").document(currentUser.uid).updateData([
                "memesDownvoted" : FieldValue.arrayUnion([meme.memeUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating user votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        
        MemeController.shared.changeVotesfor(meme: meme, upvoted: upvoted, downvoted: downvoted) { (error) in
            if let error = error {
                print("There was an error changing votes for meme: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func updateUserCommentVotesWith(comment: Comment, upvoted: Bool, downvoted: Bool, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        if upvoted {
            db.collection("users").document(currentUser.uid).updateData([
                "commentsUpvoted" : FieldValue.arrayUnion([comment.commentUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating user votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else {
            db.collection("users").document(currentUser.uid).updateData([
                "commentsDownvoted" : FieldValue.arrayUnion([comment.commentUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating user votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        
        CommentController.shared.updateCommentVotesFor(comment: comment, upvoted: upvoted, downvoted: downvoted) { (error) in
            if let error = error {
                print("There was an error changing votes for comment: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func signInUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("There was an error signing in the user: \(error) : \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func signOutUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("There was an error signing the user out: \(error) : \(error.localizedDescription) : \(#function)")
            completion(error)
            return
        }
        completion(nil)
    }
}
