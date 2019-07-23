//
//  InvestmentCollectionViewCell.swift
//  Meme Trader
//
//  Created by Will morris on 7/23/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class InvestmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var investment: Investment? {
        didSet {
            updateViews()
        }
    }
    
    var meme: Meme?
    
    func updateViews() {
        guard let investment = investment,
            let meme = meme
            else { return }
        
        if let bought = investment.amountBought {
            spentLabel.text = String(format: "%.2f", bought)
        }
        
        valueLabel.text = String(format: "%.2f", meme.value)
        sharesLabel.text = "\(Int(investment.numberOfShares))"
        dateLabel.text = investment.date.collectionDate()
        sellButton.setTitle("Sell for $\(String(format: "%.2f", investment.numberOfShares * meme.value))", for: .normal)
    }
}
