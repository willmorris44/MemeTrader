//
//  MemeListTableViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/15/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class MemeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noMemeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noMemeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var filter: String? {
        get {
            return AppDelegate.filter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func reloadButtonTapped(_ sender: Any) {
        guard let filter = filter else { return }
        MemeController.shared.fetchMemesFromFirestoreWith(filter: filter) { (error) in
            if let error = error {
                print("There was an error fetching memes for \(filter): \(error) : \(error.localizedDescription) : \(#function)")
                return
            }
            DispatchQueue.main.async {
                self.setupUI()
                self.tableView.reloadData()
                return
            }
        }
    }
    
    func setupUI() {
        if let filter = filter, let memeArray = MemeController.shared.memesDic[filter], memeArray.count > 0, noMemeView != nil {
            noMemeView.removeFromSuperview()
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        } else {
            //self.view.addSubview(noMemeView)
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filter = filter,
            let memeArray = MemeController.shared.memesDic[filter]
            else { return 0 }
        
        return memeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as? MemeTableViewCell
        
        guard let filter = filter,
            let memeArray = MemeController.shared.memesDic[filter]
            else { return UITableViewCell() }
        
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMemeDetail" {
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MemeDetailViewController,
                let filter = filter,
                let memeArray = MemeController.shared.memesDic[filter]
                else { return }
            
            let meme = memeArray[index.row]
            destinationVC.meme = meme
        }
    }
}

extension MemeListViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addMeme = storyboard.instantiateViewController(withIdentifier: "addMeme")
            addMeme.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            navigationController?.present(addMeme, animated: true, completion: nil)
        }
    }
}

extension MemeListViewController: MemeTableViewCellDelegate {
    
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
