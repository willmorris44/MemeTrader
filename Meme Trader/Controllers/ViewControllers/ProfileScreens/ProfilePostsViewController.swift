//
//  ProfilePostsViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/19/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class ProfilePostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        guard let user = UserController.currentUser else { return }
        MemeController.shared.fetchMemesFor(user: user) { (error) in
            if let error = error {
                print("There was an error in profileviewcontroller: \(error) : \(#function)")
                return
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let memeArray = MemeController.shared.memesDic["currentUserMemes"] else { return 0 }
        return memeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as? MemeTableViewCell
        
        guard let memeArray = MemeController.shared.memesDic["currentUserMemes"] else { return UITableViewCell() }
        
        let meme = memeArray[indexPath.row]
        
        cell?.view.layer.cornerRadius = 25
        cell?.view.layer.masksToBounds = true
        cell?.shadow.layer.cornerRadius = 25
        cell?.percentChangedLabel.layer.cornerRadius = 4
        cell?.percentChangedLabel.layer.masksToBounds = true
        cell?.memeImageView.image = meme.image
        cell?.meme = meme
        cell?.delegate = self
        
        return cell ?? UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMemeDetail" {
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MemeDetailViewController,
                let memeArray = MemeController.shared.memesDic["currentUserMemes"]
                else { return }
            
            let meme = memeArray[index.row]
            destinationVC.meme = meme
        }
    }
}

extension ProfilePostsViewController: MemeTableViewCellDelegate {
    func buyButtonTapped(meme: Meme) {
        
    }
    
    func sellButtonTapped() {
        
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
