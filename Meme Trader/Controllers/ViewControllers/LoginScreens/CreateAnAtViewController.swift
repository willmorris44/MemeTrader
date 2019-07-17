//
//  CreateAnAtViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class CreateAnAtViewController: UIViewController {

    @IBOutlet weak var tagTextField: TextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let tag = tagTextField.text,
            !tag.isEmpty
            else { presentAlert(1); return }
        
        UserController.shared.checkUserTagWith(tag: tag) { (result, error) in
            if let error = error {
                print("There was an error checking tag: \(error) : \(error.localizedDescription) : \(#function)")
                self.presentAlert(2)
                return
            }
            
            if result {
                self.performSegue(withIdentifier: "toAddInfo", sender: self)
            }
        }
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        tagTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        setUpTextField(tagTextField)
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
            let alert = UIAlertController(title: "Error", message: "Field cannot be empty", preferredStyle: .alert)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddInfo" {
            guard let destinationVC = segue.destination as? AddInfoViewController else { return }
            destinationVC.tag = tagTextField.text
        }
    }
}
