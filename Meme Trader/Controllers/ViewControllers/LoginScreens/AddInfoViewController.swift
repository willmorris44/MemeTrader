//
//  AddInfoViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class AddInfoViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    let lightGray = UIColor(displayP3Red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
    let green = UIColor(displayP3Red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    
    var tag: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        bioTextView.delegate = self
        setUpConstraints()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAddProfilePic", sender: self)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        nameTextField.text = ""
        bioTextView.text = ""
        performSegue(withIdentifier: "toAddProfilePic", sender: self)
    }
    
    func setUpConstraints() {
        
        // Textfields
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        setUpTextField(nameTextField)
        setUpTextView(bioTextView)
    }
    
    func setUpTextView(_ textView: UITextView) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 10, y: textView.frame.height + 40, width: textView.frame.width - 20, height: 1)
        bottomLine.backgroundColor = green.cgColor // background color
        textView.layer.addSublayer(bottomLine)
    }
    
    func setUpTextField(_ yourTextFieldName: UITextField)  {
        // Bottom Border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 10, y: yourTextFieldName.frame.height + 25, width: yourTextFieldName.frame.width - 20, height: 1)
        bottomLine.backgroundColor = green.cgColor // background color
        yourTextFieldName.borderStyle = UITextField.BorderStyle.none // border style
        yourTextFieldName.layer.addSublayer(bottomLine)
        
        // Text Color
        yourTextFieldName.textColor = green
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddProfilePic" {
            guard let destinationVC = segue.destination as? AddProfilePictureViewController else { return }
            destinationVC.tag = tag
            destinationVC.name = nameTextField.text
            destinationVC.bio = bioTextView.text
        }
    }
}

extension AddInfoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Add a bio to your profile"
            textView.textColor = lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == lightGray && !text.isEmpty {
            textView.textColor = green
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            return changedText.count <= 81
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
