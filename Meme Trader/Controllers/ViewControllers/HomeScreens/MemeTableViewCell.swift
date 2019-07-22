//
//  MemeTableViewCell.swift
//  Meme Trader
//
//  Created by Will morris on 7/15/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase

protocol MemeTableViewCellDelegate: class {
    func optionButtonTapped()
    func buyButtonTapped(meme: Meme)
    func sellButtonTapped()
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
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var fundButton: UIButton!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var shadow: UIView!
    
    weak var delegate: MemeTableViewCellDelegate?
    
    var votes: Double?
    
    var upvote = false
    var downvote = false
    
    var meme: Meme? {
        didSet {
            updateViews()
        }
    }
    
    var investment: Investment?
    
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
        sizeAvi()
        sellButton.setTitleColor(.lightGray, for: .disabled)
        fundButton.setTitleColor(.lightGray, for: .disabled)
        buyButton.setTitleColor(.lightGray, for: .disabled)
    
        guard let meme = meme,
            let currentUser = UserController.currentUser
            else { print("Meme couldn't unwrap: \(#function)"); return }
        
        checkVotes(currentUser, meme)
        profilePicImageView.image = user.avi
        profileNameLabel.text = user.name
        profileTagLabel.text = user.tag
        captionLabel.text = meme.caption
        memeImageView.bounds.size.width = UIScreen.main.bounds.width
        stockValueLabel.text = "\(meme.value)"
        percentChangedLabel.text = "%\(meme.rateOfVotes)"
        fundButton.isEnabled = false
        
        if investment == nil {
            sellButton.isEnabled = false
        } else {
            sellButton.isEnabled = true
        }
        
        if meme.userUID == currentUser.userUID {
            buyButton.isEnabled = false
        } else {
            buyButton.isEnabled = true
        }
    }
    
    func checkVotes(_ user: User, _ meme: Meme) {
        if user.memesUpvoted.contains(meme.memeUID) {
            upvote = true
            downvote = false
            setVotes(vote: true)
            upvoteButton.setImage(UIImage(named: "upvoteGreen"), for: .normal)
            downvoteButton.setImage(UIImage(named: "downvoteBlack"), for: .normal)
        } else if user.memesDownvoted.contains(meme.memeUID) {
            downvote = true
            upvote = false
            setVotes(vote: false)
            upvoteButton.setImage(UIImage(named: "upvoteBlack"), for: .normal)
            downvoteButton.setImage(UIImage(named: "downvoteRed"), for: .normal)
        } else {
            setVotes(vote: nil)
            upvoteButton.setImage(UIImage(named: "upvoteBlack"), for: .normal)
            downvoteButton.setImage(UIImage(named: "downvoteBlack"), for: .normal)
        }
    }
    
    func setVotes(vote: Bool?) {
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        if vote == true {
            votes = meme.upvotes - meme.downvotes + 1
        } else if vote == false {
            votes = meme.upvotes - meme.downvotes - 1
        } else {
            votes = meme.upvotes - meme.downvotes
        }
        self.votesLabel.text = "\(Int(votes!))"
    }
    
    func sizeAvi() {
        profilePicImageView.layer.borderWidth = 0
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
        profilePicImageView.clipsToBounds = true
        profilePicImageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        self.delegate?.optionButtonTapped()
    }
    
    @IBAction func upvoteButtonTapped(_ sender: UIButton) {
        downvoteButton.setImage(UIImage(named: "downvoteBlack"), for: .normal)

        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        if upvote == true {
            UserController.shared.updateUserMemeVotesWith(meme: meme, upvoted: false, downvoted: nil, completion: { (error) in
                if let error = error {
                    print("There was an error changing user votes: \(error) : \(error.localizedDescription) : \(#function)")
                }
            })
            setVotes(vote: nil)
            upvote = false
            upvoteButton.setImage(UIImage(named: "upvoteBlack"), for: .normal)
        } else if downvote == true {
            UserController.shared.updateUserMemeVotesWith(meme: meme, upvoted: true, downvoted: false, completion: { (error) in
                if let error = error {
                    print("There was an error changing user votes: \(error) : \(error.localizedDescription) : \(#function)")
                }
            })
            setVotes(vote: true)
            upvote = true
            downvote = false
            upvoteButton.setImage(UIImage(named: "upvoteGreen"), for: .normal)
        } else {
            UserController.shared.updateUserMemeVotesWith(meme: meme, upvoted: true, downvoted: nil, completion: { (error) in
                if let error = error {
                    print("There was an error changing user votes: \(error) : \(error.localizedDescription) : \(#function)")
                }
            })
            setVotes(vote: true)
            upvote = true
            upvoteButton.setImage(UIImage(named: "upvoteGreen"), for: .normal)
        }
        reloadInputViews()
    }
    
    @IBAction func downvoteButtonTapped(_ sender: UIButton) {
        upvoteButton.setImage(UIImage(named: "upvoteBlack"), for: .normal)
        
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        if downvote == true {
            UserController.shared.updateUserMemeVotesWith(meme: meme, upvoted: nil, downvoted: false, completion: { (error) in
                if let error = error {
                    print("There was an error changing user votes: \(error) : \(error.localizedDescription) : \(#function)")
                }
            })
            setVotes(vote: nil)
            downvote = false
            downvoteButton.setImage(UIImage(named: "downvoteBlack"), for: .normal)
        } else if upvote == true {
            UserController.shared.updateUserMemeVotesWith(meme: meme, upvoted: false, downvoted: true, completion: { (error) in
                if let error = error {
                    print("There was an error changing user votes: \(error) : \(error.localizedDescription) : \(#function)")
                }
            })
            setVotes(vote: false)
            downvote = true
            upvote = false
            downvoteButton.setImage(UIImage(named: "downvoteRed"), for: .normal)
        } else {
            UserController.shared.updateUserMemeVotesWith(meme: meme, upvoted: nil, downvoted: true, completion: { (error) in
                if let error = error {
                    print("There was an error changing user votes: \(error) : \(error.localizedDescription) : \(#function)")
                }
            })
            setVotes(vote: false)
            downvote = true
            downvoteButton.setImage(UIImage(named: "downvoteRed"), for: .normal)
        }
        reloadInputViews()
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        guard let meme = meme else { print("Meme couldn't unwrap: \(#function)"); return }
        delegate?.buyButtonTapped(meme: meme)
    }
    
    @IBAction func sellButtonTapped(_ sender: UIButton) {
        delegate?.sellButtonTapped()
    }
    
    @IBAction func fundButtonTapped(_ sender: Any) {
    }
}
