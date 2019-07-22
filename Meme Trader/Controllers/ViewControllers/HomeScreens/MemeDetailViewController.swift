//
//  MemeDetailViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/15/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTagLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var meme: Meme? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        loadViewIfNeeded()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        optionButtonTapped()
    }
    
    func updateViews() {
        sizeAvi()
        
        guard let meme = meme,
            let user = UserController.shared.userDic[meme.memeUID]
            else { print("Meme couldn't unwrap: \(#function)"); return }
        
        profilePicImageView.image = user.avi
        profileNameLabel.text = user.name
        profileTagLabel.text = user.tag
        memeImageView.image = meme.image
        captionLabel.text = meme.caption
    }
    
    func sizeAvi() {
        profilePicImageView.layer.borderWidth = 0
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
        profilePicImageView.clipsToBounds = true
        profilePicImageView.contentMode = .scaleAspectFill
    }
    
    func optionButtonTapped() {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        let report = UIAlertAction(title: "Report", style: .destructive, handler: nil)
        let block = UIAlertAction(title: "Block", style: .destructive, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(report)
        alert.addAction(block)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
