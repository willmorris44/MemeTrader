//
//  LaunchViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/15/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let _ = Auth.auth().currentUser {
            guard let filter = AppDelegate.filter else { return }
            UserController.shared.getCurrentUser { (error) in
                if let error = error {
                    print(error)
                    return
                }
            }
            
            InvestmentController.shared.fetchInvestmentsFromFirestoreFor { (error) in
                if let error = error {
                    print(error)
                    return
                }
            }
            
            MemeController.shared.fetchMemesFromFirestoreWith(filter: filter) { (error) in
                if let error = error {
                    print("There was an error fetching memes for \(filter): \(error) : \(error.localizedDescription) : \(#function)")
                    return
                }
                let mainVC = main.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
                UIApplication.shared.windows.first?.rootViewController = mainVC
            }
        } else {
            let loginVC = login.instantiateViewController(withIdentifier: "loginScreen")
            UIApplication.shared.windows.first?.rootViewController = loginVC
        }

    }
}
