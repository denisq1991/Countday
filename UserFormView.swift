//
//  UserFormView.swift
//  nv-comms
//
//  Created by Denis Quaid on 15/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

protocol UserFormDelegate {
    func saveUser(name: String, email: String)
    func presentViewController(imagePicker: UIImagePickerController)
    func dismissViewController()
}

class UserFormView : UIView, UIImagePickerControllerDelegate {
    
    @IBOutlet var userNameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var imageView: UIImageView?
    let imagePicker = UIImagePickerController()
    
    var delegate: UserFormDelegate?
    
    func willMoveToSuperview(newSuperview: UIView) {
        self.imagePicker.delegate? = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        super.willMove(toSuperview: newSuperview)
    }
    
    @IBAction func didAddNewUser(sender: Any) {
        guard let userName: String = self.userNameTextField?.text,
            let emailAddress: String = self.emailTextField?.text else {
                return
        }
        
        self.delegate?.saveUser(name: userName, email: emailAddress)
    }
    
     @IBAction func didAddNewImage(sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary

        self.delegate?.presentViewController(imagePicker: self.imagePicker)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.image = pickedImage
        }
        self.delegate?.dismissViewController()
    }
}

