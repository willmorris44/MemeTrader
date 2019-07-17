//
//  MemeTableViewCell.swift
//  Meme Trader
//
//  Created by Will morris on 7/15/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

protocol MemeTableViewCellDelegate: class {
    func optionButtonTapped()
}

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTagLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var stockValueLabel: UILabel!
    @IBOutlet weak var percentChangedLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var downvotesLabel: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var fundButton: UIButton!
    @IBOutlet weak var coinImageView: UIImageView!
    
    weak var delegate: MemeTableViewCellDelegate?
    
    var meme: Meme? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        if let user = UserController.shared.userDic[meme.memeUID] {
            setupUI(user: user)
        } else {
            UserController.shared.fetchUserWith(uid: meme.userUID, memeUID: meme.memeUID) { (user, error) in
                if let error = error {
                    print("There was an error fetching user: \(error) : \(error.localizedDescription) : \(#function)")
                    return
                }
                
                guard let user = user else { print("User couldn't unwrap: \(#function)"); return }
                self.setupUI(user: user)
            }
        }
    }
    
    func setupUI(user: User) {
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        self.profilePicImageView.image = user.avi
        self.profileNameLabel.text = user.name
        self.profileTagLabel.text = user.tag
        self.captionLabel.text = meme.caption
        self.memeImageView.image = meme.image
        self.stockValueLabel.text = "\(meme.value)"
        //self.percentChangedLabel.text
        self.votesLabel.text = "\(meme.upvotes - meme.downvotes)"
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        self.delegate?.optionButtonTapped()
    }
    
    @IBAction func upvoteButtonTapped(_ sender: UIButton) {
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        MemeController.shared.changeVotesfor(meme: meme, upvoted: true, downvoted: false) { (error) in
            if let error = error {
                print("There was an error changing meme votes: \(error) : \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    @IBAction func downvoteButtonTapped(_ sender: UIButton) {
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        MemeController.shared.changeVotesfor(meme: meme, upvoted: false, downvoted: true) { (error) in
            if let error = error {
                print("There was an error changing meme votes: \(error) : \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func sellButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func fundButtonTapped(_ sender: Any) {
    }
}
