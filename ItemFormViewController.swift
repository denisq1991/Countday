//
//  ItemFormViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 15/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ItemFormDelegate {
    func saveItem(title: String, subtitle: String, image: UIImage?)
    func addNewImage()
}

func getDocumentsURL() -> NSURL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL as NSURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL!.path
}

class ItemFormViewController: UIViewController, ItemFormDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var itemFormView: ItemFormView?
    var imagePicker: UIImagePickerController?
    
    // Define the specific path, image name
    let imagePath:  String? = nil //fileInDocumentsDirectory(myImageName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create New Item"
        self.itemFormView?.delegate = self
        self.imagePicker = UIImagePickerController()
    }
    
    func saveItem(title: String, subtitle: String, image: UIImage?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(title, forKeyPath: "title")
        item.setValue(subtitle, forKeyPath: "subtitle")
        
        self.saveImage(image: image, path:title )
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.dismiss(animated: true)
    }
    
    func saveImage (image: UIImage?, path: String ){
        if (image != nil) {
            let pngImageData = UIImagePNGRepresentation(image!)
            let pathUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(path).png")
            print("Saving to \(pathUrl)")
            do {
                try pngImageData!.write(to: pathUrl, options: .atomic)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func addNewImage() {
        guard let imagePicker = self.imagePicker else {
            return
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            guard let imageView = self.itemFormView?.imageView else {
                print("Invalid image view")
                return
            }
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

class ItemFormView : UIView {
    
    @IBOutlet var titleTextField: UITextField?
    @IBOutlet var subtitleTextField: UITextField?
    @IBOutlet var imageView: UIImageView?
    
    var delegate: ItemFormDelegate?
    
    func willMoveToSuperview(newSuperview: UIView) {
        super.willMove(toSuperview: newSuperview)
    }
    
    @IBAction func didAddNewItem(sender: Any) {
        guard let title: String = self.titleTextField?.text,
            let subtitle: String = self.subtitleTextField?.text else {
                return
        }
        
        let image: UIImage? = self.imageView?.image
        self.delegate?.saveItem(title: title, subtitle: subtitle, image: image)
    }
    
    @IBAction func addNewImage(sender: Any) {
        self.delegate?.addNewImage()
    }
    
    
}

