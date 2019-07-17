//
//  SignupViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentingViewController?.dismiss(animated: true, completion: nil)
        setUpConstraints()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
            else { presentAlert(1); return }
        
        UserController.shared.createUserWith(email: email, password: password) { (error) in
            if let error = error {
                print("There was an error creating the user: \(error) : \(error.localizedDescription) : \(#function)")
                self.presentAlert(2)
                return
            }
            
            self.performSegue(withIdentifier: "toNavController", sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        // Bottom Border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 10, y: yourTextFieldName.frame.height + 25, width: yourTextFieldName.frame.width - 20, height: 1)
        bottomLine.backgroundColor = green.cgColor // background color
        yourTextFieldName.borderStyle = UITextField.BorderStyle.none // border style
        yourTextFieldName.layer.addSublayer(bottomLine)

        // Text Color
        yourTextFieldName.textColor = green
    }
    
    func presentAlert(_ type: Int) {
        if type == 1 {
            let alert = UIAlertController(title: "Error", message: "Both fields must be filled", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(okayAction)
            present(alert, animated: true)
        } else if type == 2 {
            let alert = UIAlertController(title: "Error", message: "Please try again", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(okayAction)
            present(alert, animated: true)
        }
    }
}
