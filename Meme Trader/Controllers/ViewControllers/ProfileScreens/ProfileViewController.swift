//
//  ProfileViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/16/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let currentUser = UserController.currentUser
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var postsView: UIView!
    @IBOutlet weak var commentsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    func setupUI() {
        guard let name = currentUser?.name,
            let tag = currentUser?.tag,
            let bio = currentUser?.bio,
            let money = currentUser?.cash,
            let avi = currentUser?.avi
            else { return }
        
        nameLabel.text = name
        tagLabel.text = tag
        bioLabel.text = bio
        moneyLabel.text = "$\(money)"
        aviImageView.image = avi
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
