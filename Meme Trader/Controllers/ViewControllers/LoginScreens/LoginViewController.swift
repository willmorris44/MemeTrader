//
//  LoginViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentingViewController?.dismiss(animated: true, completion: nil)
        setUpConstraints()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else { presentAlert(2); return }
        
        UserController.shared.signInUserWith(email: email, password: password) { (error) in
            if let error = error {
                print("There was an error signing in the user: \(error) : \(error.localizedDescription) : \(#function)")
                self.presentAlert(1)
                return
            }
            
            UserController.shared.getCurrentUser(completion: { (error) in
                if let error = error {
                    print("error: \(error)")
                    return
                }
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            })
        }
    }
    
    func setUpConstraints() {
        
        // Textfields
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        setUpTextField(emailTextField)
        setUpTextField(passwordTextField)
    }
    
    func setUpTextField(_ yourTextFieldName: UITextField)  {
        
        let green = UIColor(displayP3Red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        // Text Color
        yourTextFieldName.textColor = green
    }
    
    func presentAlert(_ type: Int) {
        if type == 1 {
            let alert = UIAlertController(title: "Error", message: "The email or password is incorrect. Do you have an account?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes, Let me try again", style: .default, handler: nil)
            let noAction = UIAlertAction(title: "No, Sign me up!", style: .default) { (_) in
                self.performSegue(withIdentifier: "toSignup", sender: self)
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true)
        } else if type == 2 {
            let alert = UIAlertController(title: "Error", message: "Please enter email AND password", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(okayAction)
            present(alert, animated: true)
        }
    }
}
