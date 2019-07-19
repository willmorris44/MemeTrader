//
//  ThisIsYouViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase

class ThisIsYouViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    var pic: UIImage?
    var tag: String?
    var name: String?
    var bio: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let green = UIColor(displayP3Red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = green.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        profilePic.contentMode = .scaleAspectFill
        
        nameLabel.text = name
        tagLabel.text = tag
        bioLabel.text = bio
        profilePic.image = pic
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        finishButton.isEnabled = false
        guard let tag = tag,
            let name = name,
            let bio = bio,
            let pic = pic,
            let currentUserUID = Auth.auth().currentUser?.uid
            else { finishButton.isEnabled = true; return }
        
        UserController.shared.uploadProfilePicWith(image: pic, userUID: currentUserUID) { (url, error) in
            if let error = error {
                print("There was an error uploading pic: \(error) : \(error.localizedDescription) : \(#function)")
                self.finishButton.isEnabled = true
                return
            }
            
            guard let url = url else { return }
            UserController.shared.updateUserInfoWith(tag: tag, name: name, bio: bio, picUrl: url) { (error) in
                if let error = error {
                    print("There was an error updating the user info: \(error) : \(error.localizedDescription) : \(#function)")
                    self.finishButton.isEnabled = true
                    return
                }
                UserController.shared.getCurrentUser(completion: { (error) in
                    if let error = error {
                        print("Error getting current user: \(error) : \(#function)")
                        return
                    }
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                })
            }
        }
    }
}
