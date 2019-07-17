//
//  AddProfilePictureViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/8/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class AddProfilePictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var tag: String?
    var name: String?
    var bio: String?
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func profilePicButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true)
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        profilePic.image = UIImage(named: "defaultProfilePic")
        performSegue(withIdentifier: "toThisIsYou", sender: self)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toThisIsYou", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePic.contentMode = .scaleAspectFill
            profilePic.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        let green = UIColor(displayP3Red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = green.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toThisIsYou" {
            guard let destinationVC = segue.destination as? ThisIsYouViewController else { return }
            destinationVC.pic = profilePic.image
            destinationVC.tag = tag
            destinationVC.name = name
            destinationVC.bio = bio
        }
    }
}
