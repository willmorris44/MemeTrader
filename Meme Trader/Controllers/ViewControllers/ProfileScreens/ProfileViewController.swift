//
//  ProfileViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/16/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var currentUser: User? {
        return UserController.currentUser
    }
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var postsView: UIView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var segCon: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    @IBAction func segConTapped(_ sender: Any) {
        if segCon.selectedSegmentIndex == 1 {
            postsView.isHidden = true
            commentsView.isHidden = false
        } else {
            postsView.isHidden = false
            commentsView.isHidden = true
        }
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    func setupUI() {
        sizeAvi()
                
        guard let name = currentUser?.name,
            let tag = currentUser?.tag,
            let bio = currentUser?.bio,
            let money = currentUser?.cash,
            let avi = currentUser?.avi
            else { return }
        
        nameLabel.text = name
        tagLabel.text = tag
        bioLabel.text = bio
        moneyLabel.text = "\(String(format: "%.2f", money)) keks"
        aviImageView.image = resize(image: avi)
        headerImageView.image = UIImage(named: "defaultProfilePic")
        
    }
    
    func sizeAvi() {
        aviImageView.layer.borderWidth = 2.5
        aviImageView.layer.borderColor = UIColor.white.cgColor
        aviImageView.layer.masksToBounds = false
        aviImageView.layer.cornerRadius = aviImageView.frame.height/2
        aviImageView.clipsToBounds = true
        aviImageView.contentMode = .scaleAspectFill
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toProfileEdit" {
            guard let destinationVC = segue.destination as? EditProfileViewController else { return }
            destinationVC.currentUser = currentUser
        }
    }
}
