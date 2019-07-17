//
//  AddMemeViewController.swift
//  Meme Trader
//
//  Created by Will morris on 7/15/19.
//  Copyright © 2019 Will morris. All rights reserved.
//

import UIKit

class AddMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        guard let image = memeImageView.image else { return }
        MemeController.shared.createMemeWith(caption: captionTextView.text, image: image) { (error) in
            if let error = error {
                print("There was an error creating the meme: \(error) : \(error.localizedDescription) : \(#function)")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseImageButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            memeImageView.contentMode = .scaleAspectFill
            memeImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
