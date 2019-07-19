//
//  AppDelegate.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let defaults = UserDefaults.standard
    
    let filterArray = ["new", "hotDaily", "hotWeekly", "topDaily", "topWeekly", "topMonthly", "topYearly", "topAlltime"]
    
    static var filter: String?
    
    static var darkMode = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if AppDelegate.filter == nil {
            AppDelegate.filter = "new"
        } else {
            AppDelegate.filter = filterArray[defaults.integer(forKey: "filter")]
        }
        
        AppDelegate.darkMode = defaults.bool(forKey: "darkMode")

//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("There was an error signing the user out: \(error) : \(error.localizedDescription) : \(#function)")
//        }
        
        return true
    }
}

