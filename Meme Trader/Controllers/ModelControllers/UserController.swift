//
//  UserController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserController {
    
    // MARK: - Properties
    
    static let shared = UserController()
    
    static var currentUser: User?
    
    lazy var db = Firestore.firestore()
    
    lazy var storageRef = StorageReference()
    
    var userDic: [String: User] = [:]
    
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
    
    func resize(image: UIImage) -> UIImage? {
        let oldWidth = image.size.width
        let newWidth = UIScreen.main.bounds.width
        let scalor = newWidth / oldWidth
        let newHeight = image.size.height * scalor
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func uploadProfilePicWith(image: UIImage, userUID: String, completion: @escaping (String?, Error?) -> Void) {
        let newImage = resize(image: image)
        
        guard let image = newImage,
            let data = image.pngData()
            else { return }
        
        let ref = storageRef.child("images/profilePic/\(userUID).png")
        ref.putData(data, metadata: nil) { (_, error) in
            if let error = error {
                print("Error uploading image: \(error) : \(error.localizedDescription): \(#function)")
                completion(nil, error)
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting url: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(nil, error)
                    return
                }
                
                guard let url = url?.absoluteString else { return }
                completion(url, nil)
            }
        }
    }
    
    func updateUserInfoWith(tag: String, name: String, bio: String, picUrl: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        db.collection("users").document(currentUser.uid).updateData([
            "tag" : tag,
            "name" : name,
            "bio" : bio,
            "picUrl" : picUrl,
            "cash" : 0.0,
            "portfolioValue" : 0.0,
            "networth" : 0.0,
            "investments" : [],
            "memes" : [],
            "comments" : [],
            "memesUpvoted" : [],
            "memesDownvoted" : [],
            "commentsUpvoted" : [],
            "commentsDownvoted" : []
        ]) { (error) in
            if let error = error {
                print("There was an error adding user info: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    func checkUserTagWith(tag: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("users").whereField("tag", isEqualTo: tag).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error checking user tag: \(error) : \(error.localizedDescription) : \(#function)")
                completion(false, error)
                return
            }
            
            guard let snapshot = snapshot,
                snapshot.documents.count == 0
                else { print(#function); completion(false, Errors.unwrapSnapshot); return }
            
            completion(true, nil)
        }
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
    
    func updateUserMemeVotesWith(meme: Meme, upvoted: Bool?, downvoted: Bool?, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        if upvoted == true{
            db.collection("users").document(currentUser.uid).updateData([
                "memesUpvoted" : FieldValue.arrayUnion([meme.memeUID]),
                "memesDownvoted" : FieldValue.arrayRemove([meme.memeUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating user votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else if downvoted == true {
            db.collection("users").document(currentUser.uid).updateData([
                "memesDownvoted" : FieldValue.arrayUnion([meme.memeUID]),
                "memesUpvoted" : FieldValue.arrayRemove([meme.memeUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating user votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else {
            db.collection("users").document(currentUser.uid).updateData([
                "memesUpvoted" : FieldValue.arrayRemove([meme.memeUID]),
                "memesDownvoted" : FieldValue.arrayRemove([meme.memeUID])
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
    
    func fetchUserWith(uid: String, memeUID: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("There was an error fetching the user with uid: \(error) : \(error.localizedDescription) : \(#function)")
                completion(nil, error)
                return
            }
            
            guard let data = snapshot?.data() else { print(#function); completion(nil, Errors.unwrapSnapshot); return }
            guard let docID = snapshot?.documentID else { print(#function); completion(nil, Errors.unwrapDocumentID); return }
            guard var user = User(from: data, uid: docID) else { print(#function); completion(nil, Errors.decodeUser); return }
            
            let pathRef = self.storageRef.child("images/profilePic/\(user.userUID).png")
            pathRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    print("There was an error downloading avi: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(nil, error)
                    return
                }
                
                guard let data = data,
                    let image = UIImage(data: data)
                    else { return }
                
                let newImage = self.resize(image: image)
                user.avi = newImage
                self.userDic[memeUID] = user
                completion(user, nil)
            })
        }
    }
    
    func getCurrentUser(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("There was an error getting current user: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
            
            guard let snapshot = snapshot,
                let data = snapshot.data()
                else { print(#function); completion(Errors.unwrapSnapshot); return }
            
            let user = User(from: data, uid: snapshot.documentID)
            UserController.currentUser = user
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
