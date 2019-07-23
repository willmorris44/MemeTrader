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
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    var filter: String? {
        get {
            return AppDelegate.filter
        }
    }
    
    var meme: Meme?
    
    let green = UIColor(displayP3Red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    let lightGray = UIColor(displayP3Red: 0.78, green: 0.78, blue: 0.8, alpha: 0.40)
    
    let sliderLabel = UILabel()
    let slider = UISlider()
    let buyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func reloadButtonTapped(_ sender: Any) {
        guard let filter = filter else { return }
        reloadButton.isEnabled = false
        MemeController.shared.fetchMemesFromFirestoreWith(filter: filter) { (error) in
            if let error = error {
                print("There was an error fetching memes for \(filter): \(error) : \(error.localizedDescription) : \(#function)")
                return
            }
            DispatchQueue.main.async {
                self.reloadButton.isEnabled = true
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
    
    func buyButtonTapped(meme: Meme) {
        guard let user = UserController.currentUser else { return }
        
        self.meme = meme
        
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let bottomView = UIView()
        let valueLabel = UILabel()
        let kekLabel = UILabel()
        let myKeksLabel = UILabel()
        let titleLabel = UILabel()
        let cancelButton = UIButton()
        
        alertController.view.addSubview(bottomView)
        alertController.view.addSubview(slider)
        alertController.view.addSubview(valueLabel)
        alertController.view.addSubview(kekLabel)
        alertController.view.addSubview(myKeksLabel)
        alertController.view.addSubview(sliderLabel)
        alertController.view.addSubview(titleLabel)
        alertController.view.addSubview(cancelButton)
        alertController.view.addSubview(buyButton)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bottomView.topAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -25).isActive = true
        bottomView.backgroundColor = .white
        
        titleLabel.text = "Buy Stonks"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 12).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        
        slider.maximumValue = Float(floor(user.cash / meme.value))
        slider.tintColor = green
        slider.value = slider.maximumValue / 2
        slider.minimumValue = 1
        slider.isEnabled = true
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -150).isActive = true
        slider.widthAnchor.constraint(equalTo: alertController.view.widthAnchor, constant: -48).isActive = true
        slider.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        
        sliderLabel.text = "\(Int(slider.value))"
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        sliderLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -4).isActive = true
        sliderLabel.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        
        valueLabel.text = "Value: \(meme.value)"
        valueLabel.textColor = .black
        valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 60).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 32).isActive = true
        
        kekLabel.text = "My Keks"
        kekLabel.textColor = .black
        kekLabel.font = UIFont.boldSystemFont(ofSize: 24)
        kekLabel.translatesAutoresizingMaskIntoConstraints = false
        kekLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 60).isActive = true
        kekLabel.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -32).isActive = true
        
        myKeksLabel.text = String(format: "%.2f", user.cash)
        myKeksLabel.textColor = .black
        myKeksLabel.font = UIFont.systemFont(ofSize: 18)
        myKeksLabel.translatesAutoresizingMaskIntoConstraints = false
        myKeksLabel.topAnchor.constraint(equalTo: kekLabel.bottomAnchor, constant: 8).isActive = true
        myKeksLabel.centerXAnchor.constraint(equalTo: kekLabel.centerXAnchor).isActive = true
        
        buyButton.setTitle("Buy for $\(String(format: "%.2f", Double(slider.value) * meme.value))", for: .normal)
        buyButton.backgroundColor = lightGray
        buyButton.setTitleColor(.black, for: .normal)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 32).isActive = true
        buyButton.widthAnchor.constraint(equalTo: alertController.view.widthAnchor, constant: -16).isActive = true
        buyButton.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buyButton.layer.cornerRadius = 25
        buyButton.addTarget(self, action: #selector(buySharesTapped), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = lightGray
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 12).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: alertController.view.widthAnchor, constant: -16).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.layer.cornerRadius = 25
        cancelButton.addTarget(self, action: #selector(dismissAlertController), for: .touchUpInside)
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 350).isActive = true
        alertController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        alertController.view.layer.cornerRadius = 25
        alertController.view.backgroundColor = .white
        alertController.view.tintColor = green
        
        let view = alertController.view.subviews.first
        view?.removeFromSuperview()

        present(alertController, animated: true)
        
//        present(alertController, animated: true) {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
//            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//        }
    }
    
    func sellButtonTapped() {
        tabBarController?.selectedIndex = 3
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard let meme = meme else { return }
        sliderLabel.text = "\(Int(slider.value))"
        buyButton.setTitle("Buy for $\(String(format: "%.2f", Double(slider.value) * meme.value))", for: .normal)
    }
    
    @IBAction func buySharesTapped(_ sender: UIButton) {
        guard let meme = meme else { return }
        let bought = Double(slider.value) * meme.value
        let shares = Int(slider.value)
        InvestmentController.shared.createInvestmentFor(meme: meme, funded: nil, bought: bought, shares: shares) { (error) in
            if let error = error {
                print("There was an error: \(error)")
                return
            }
        }
        
        self.dismissAlertController()
    }
}
