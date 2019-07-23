//
//  BoughtMemesViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/23/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class BoughtMemesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        InvestmentController.shared.fetchInvestmentsFromFirestoreFor { (error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let user = UserController.currentUser else { return }
            MemeController.shared.fetchInvestmentMemesFor(user: user, completion: { (error) in
                if let error = error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InvestmentController.shared.investmentArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "investCell", for: indexPath) as? InvestmentCollectionViewCell
        
        let investment = InvestmentController.shared.investmentArr[indexPath.row]
        var meme: Meme?
        guard let memeArr = MemeController.shared.memesDic["investments"] else { return UICollectionViewCell() }
        meme = memeArr.first { (meme) -> Bool in
            return meme.memeUID == investment.memeUID
        }
        
        cell?.mainView.layer.cornerRadius = 25
        cell?.mainView.layer.masksToBounds = true
        cell?.shadowView.layer.cornerRadius = 25
        cell?.investment = investment
        cell?.meme = meme
        cell?.sellButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cell?.sellButton.layer.cornerRadius = 25
        
        return cell ?? UICollectionViewCell()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
