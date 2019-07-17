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
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
    }
    
    func updateViews() {
        guard let meme = meme,
            let user = UserController.shared.userDic[meme.memeUID]
            else { return }
        
        profilePicImageView.image = user.avi
        profileNameLabel.text = user.name
        profileTagLabel.text = user.tag
        memeImageView.image = meme.image
        captionLabel.text = meme.caption
    }
}
