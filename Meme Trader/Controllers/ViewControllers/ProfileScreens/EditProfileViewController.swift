//
//  EditProfileViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/19/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var currentUser: User?
    
    let lightGray = UIColor(displayP3Red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
    let green = UIColor(displayP3Red: 76/255, green: 217/255, blue: 100/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        bioTextView.delegate = self
        setUpConstraints()
        setUpUI()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let bio = bioTextView.text,
            let user = currentUser,
            let image = aviImageView.image
            else { return }
        
        saveButton.isEnabled = false
        
        UserController.shared.uploadProfilePicWith(image: image, userUID: user.userUID) { (url, error) in
            if let error = error {
                print("There was an error: \(error)")
                return
            }
            
            guard let url = url else { return }
            UserController.shared.updateUserInfoWith(name: name, bio: bio, picUrl: url) { (error) in
                if let error = error {
                    print("There was an error: \(error)")
                    return
                }
                
                UserController.currentUser?.avi = image
                UserController.currentUser?.name = name
                UserController.currentUser?.bio = bio
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        saveButton.isEnabled = true
    }
    
    func setUpUI() {
        sizeAvi()
        
        guard let user = currentUser else { return }
        aviImageView.image = user.avi
        nameTextField.text = user.name
        bioTextView.text = user.bio
        headerImageView.image = UIImage(named: "defaultProfilePic")
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
        bottomLine.frame = CGRect(x: 10, y: textView.frame.height + 30, width: textView.frame.width - 20, height: 1)
        bottomLine.backgroundColor = green.cgColor // background color
        textView.layer.addSublayer(bottomLine)
    }
    
    func setUpTextField(_ yourTextFieldName: UITextField)  {
        // Bottom Border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 10, y: yourTextFieldName.frame.height + 20, width: yourTextFieldName.frame.width - 20, height: 1)
        bottomLine.backgroundColor = green.cgColor // background color
        yourTextFieldName.borderStyle = UITextField.BorderStyle.none // border style
        yourTextFieldName.layer.addSublayer(bottomLine)
        
        // Text Color
        yourTextFieldName.textColor = green
    }
    
    func sizeAvi() {
        aviImageView.layer.borderWidth = 2.5
        aviImageView.layer.borderColor = UIColor.white.cgColor
        aviImageView.layer.masksToBounds = false
        aviImageView.layer.cornerRadius = aviImageView.frame.height/2
        aviImageView.clipsToBounds = true
        aviImageView.contentMode = .scaleAspectFill
    }
}

extension EditProfileViewController: UITextViewDelegate {
    
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
