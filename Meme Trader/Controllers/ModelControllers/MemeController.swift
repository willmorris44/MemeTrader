//
//  MemeController.swift
//  Meme Trader
//
//  Created by Will morris on 7/9/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MemeController {
    
    // MARK: - Properties
    
    static let shared = MemeController()
    
    let db = UserController.shared.db
    
    let storageRef = UserController.shared.storageRef
    
    var memesDic: [String: [Meme]] = ["new":[], "hotDaily":[], "hotWeekly":[], "topDaily":[], "topWeekly":[], "topMonthly":[], "topYearly":[], "topAlltime":[]]
    
    // MARK: - Methods
    
    func createMemeWith(caption: String, image: UIImage, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { print(#function); completion(Errors.noCurrentUser); return }
        var ref: DocumentReference?
        ref = db.collection("memes").addDocument(data: [
            "userUID" : currentUser.uid,
            "caption" : caption,
            "date" : FieldValue.serverTimestamp(),
            "upvotes" : 0.0,
            "downvotes" : 0.0,
            "rateOfVotes" : 0.0,
            "comments" : [],
            "numOfComments" : 0.0,
            "sharesBought" : 0.0,
            "value" : 0.0
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
                    
                    guard let newImage = self.resize(image: image),
                        let data = newImage.pngData()
                        else { return }
                    
                    let storeRef = self.storageRef.child("images/meme/\(docID).png")
                    storeRef.putData(data, metadata: nil) { (_, error) in
                        if let error = error {
                            print("Error uploading image: \(error) : \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                        
                        storeRef.downloadURL { (url, error) in
                            if let error = error {
                                print("Error getting url: \(error) : \(error.localizedDescription) : \(#function)")
                                completion(error)
                                return
                            }
                            
                            guard let url = url?.absoluteString else { return }
                            self.db.collection("memes").document(docID).updateData([
                                "picUrl" : url
                                ], completion: { (error) in
                                    if let error = error {
                                        print(error)
                                        completion(error)
                                        return
                                    }
                            })
                        }
                    }
                    completion(nil)
                }
        })
    }
    
    func deleteMeme(_ meme: Meme, completion: @escaping (Error?) -> Void) {
        
    }
    
    func updateMemeWith(url: String, memeUID: String, completion: @escaping (Error?) -> Void) {
        db.collection("memes").document(memeUID).updateData([
            "picUrl" : url
        ]) { (error) in
            if let error = error {
                print("There was an error updating the meme: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        completion(nil)
        return
    }
    
    func changeVotesfor(meme: Meme, upvoted: Bool?, downvoted: Bool?, completion: @escaping (Error?) -> Void) {
        if upvoted == true {
            db.collection("memes").document(meme.memeUID).updateData([
                "upvotes" : FieldValue.increment(1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else if upvoted == false {
            db.collection("memes").document(meme.memeUID).updateData([
                "upvotes" : FieldValue.increment(-1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        
        if downvoted == true {
            db.collection("memes").document(meme.memeUID).updateData([
                "downvotes" : FieldValue.increment(1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else if downvoted == false {
            db.collection("memes").document(meme.memeUID).updateData([
                "downvotes" : FieldValue.increment(-1.0)
            ]) { (error) in
                if let error = error {
                    print("There was an error updating the memes votes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        completion(nil)
        return
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
        return
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
    
//    func uploadMemePicWith(image: UIImage, memeUID: String, completion: @escaping (String?, Error?) -> Void) {
//        let newImage = resize(image: image)
//
//        guard let resizedImage = newImage,
//            let data = resizedImage.pngData()
//            else { return }
//
//        let ref = storageRef.child("images/meme/\(memeUID).png")
//        ref.putData(data, metadata: nil) { (_, error) in
//            if let error = error {
//                print("Error uploading image: \(error) : \(error.localizedDescription) : \(#function)")
//                completion(nil, error)
//                return
//            }
//
//            ref.downloadURL { (url, error) in
//                if let error = error {
//                    print("Error getting url: \(error) : \(error.localizedDescription) : \(#function)")
//                    completion(nil, error)
//                    return
//                }
//
//                guard let url = url?.absoluteString else { return }
//                completion(url, nil)
//            }
//        }
//    }
    
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
        return
    }
    
    func fetchMemesFromFirestoreWith(filter: String, completion: @escaping (Error?) -> Void) {
        var results: [String]?
        if filter == "new" {
            db.collection("memes").limit(to: 50).order(by: "date", descending: true).getDocuments(completion: { (snapshot, error) in
                self.memesDic[filter] = []
                if let error = error {
                    print("There was an error fetching the memes: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
                
                guard let snapshot = snapshot,
                    snapshot.documents.count > 0
                    else { print(#function); completion(Errors.unwrapSnapshot); return }
                
//                self.memesDic[filter] = snapshot.documents.compactMap { Meme(from: $0.data(), uid: $0.documentID) }
                guard self.memesDic[filter]!.count == 0 else { return }
                for doc in snapshot.documents {
                    guard var meme = Meme(from: doc.data(), uid: doc.documentID) else { print("OOOOOOOOBABYE"); return }
                    
                    let pathRef = self.storageRef.child("images/meme/\(doc.documentID).png")
                    pathRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        if let error = error {
                            print("There was an error downloading images: \(error) : \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                        
                        guard let data = data,
                            let image = UIImage(data: data)
                            else { return }
                        
                        let newImage = self.resize(image: image)
                        meme.image = newImage
                        self.memesDic[filter]?.append(meme)
                        completion(nil)
                        return
                    })
                }
            })
        } else {
            self.memesDic[filter] = []
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
                self.db.collection("memes").document(result).getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        print("There was an error fetching the meme: \(error) : \(error.localizedDescription) : \(#function)")
                        completion(error)
                        return
                    }
                    
                    guard let data = snapshot?.data() else { print(#function); completion(Errors.unwrapData); return }
                    guard let docID = snapshot?.documentID else { print(#function); completion(Errors.unwrapDocumentID); return }
                    guard var meme = Meme(from: data, uid: docID) else { print(#function); completion(Errors.decodeMeme); return }
                    
                    let pathRef = self.storageRef.child("images/meme/\(docID).png")
                    pathRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        if let error = error {
                            print("There was an error downloading images: \(error) : \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                        
                        guard let data = data,
                            let image = UIImage(data: data)
                            else { return }
                        
                        let newImage = self.resize(image: image)
                        meme.image = newImage
                        self.memesDic[filter]?.append(meme)
                        completion(nil)
                        return
                    })
                })
            }
        }
    }
}

