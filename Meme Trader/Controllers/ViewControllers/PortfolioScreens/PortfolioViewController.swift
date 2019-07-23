//
//  PortfolioViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/22/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController {

    @IBOutlet weak var segCon: UISegmentedControl!
    @IBOutlet weak var boughtView: UIView!
    @IBOutlet weak var fundedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fundedView.isHidden = true
    }
    
    @IBAction func segConTapped(_ sender: Any) {
        if segCon.selectedSegmentIndex == 1 {
            fundedView.isHidden = false
            boughtView.isHidden = true
        } else {
            fundedView.isHidden = true
            boughtView.isHidden = false
        }
    }
}
