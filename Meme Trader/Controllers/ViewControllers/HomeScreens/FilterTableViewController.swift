//
//  FilterTableViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/16/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var switchZero: UISwitch!
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchTwo: UISwitch!
    @IBOutlet weak var switchThree: UISwitch!
    @IBOutlet weak var switchFour: UISwitch!
    @IBOutlet weak var switchFive: UISwitch!
    @IBOutlet weak var switchSix: UISwitch!
    @IBOutlet weak var switchSeven: UISwitch!
    
    lazy var switchArr = [switchZero, switchOne, switchTwo, switchThree, switchFour, switchFive, switchSix, switchSeven]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        setupUI()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            AppDelegate.filter = "new"
            defaults.set(0, forKey: "filter")
        case 1:
            AppDelegate.filter = "hotDaily"
            defaults.set(1, forKey: "filter")
        case 2:
            AppDelegate.filter = "hotWeekly"
            defaults.set(2, forKey: "filter")
        case 3:
            AppDelegate.filter = "topDaily"
            defaults.set(3, forKey: "filter")
        case 4:
            AppDelegate.filter = "topWeekly"
            defaults.set(4, forKey: "filter")
        case 5:
            AppDelegate.filter = "topMonthly"
            defaults.set(5, forKey: "filter")
        case 6:
            AppDelegate.filter = "topYearly"
            defaults.set(6, forKey: "filter")
        case 7:
            AppDelegate.filter = "topAlltime"
            defaults.set(7, forKey: "filter")
        default:
            return
        }
        setSwitch(sender)
    }
    
    func setSwitch(_ sender: UISwitch) {
        sender.setOn(true, animated: true)
        for i in 0...7 where i != sender.tag {
            switchArr[i]?.setOn(false, animated: true)
        }
    }
    
    func setupUI() {
        for i in 0...7 where i != defaults.integer(forKey: "filter") {
            switchArr[i]?.setOn(false, animated: false)
        }
    }
}
