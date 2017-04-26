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
import UserNotifications

protocol ItemFormDelegate {
    func saveItem(title: String, date: Date, image: UIImage?, alertOn: Bool, iconName: String?)
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
    
    let localNotificationService = LocalNotificationService()
    
    // Define the specific path, image name
    let imagePath:  String? = nil
    var currentItem: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.currentItem != nil ? "Edit An Item" : "Create New Item"
        self.setUpItemForm(item: self.currentItem)
        self.itemFormView?.delegate = self
        self.imagePicker = UIImagePickerController()
        
        if let customNavigationController = self.navigationController as? CustomNavigationController {
            customNavigationController.setNavBar(theme: .lightBlackText)
        }
    }
    
    private func setUpItemForm(item: NSManagedObject?) {
        self.itemFormView?.datePicker?.date = Date()
        self.itemFormView?.imageView?.contentMode = .center
        self.itemFormView?.imageView?.contentMode = .scaleAspectFill
        self.itemFormView?.imageView?.clipsToBounds = true
        
        let date = item?.value(forKeyPath: "date") as? Date
        let title = item?.value(forKeyPath: "title") as? String
        self.itemFormView?.titleTextField?.text = title ?? ""
        self.itemFormView?.imageView?.image = title?.loadImageFromPath()
        self.itemFormView?.datePicker?.date = date != nil ? date! : Date()
        self.itemFormView?.alertSwitcher?.isOn = item?.value(forKeyPath: "notificationActive") as? Bool ?? false
        if let iconName = item?.value(forKeyPath: "iconName") as? String {
            self.itemFormView?.selectedIconName = iconName
            self.itemFormView?.selectedIconView?.image = UIImage(named: iconName + "-grey")
        } else {
            self.itemFormView?.selectedIconName = ""
        }
        self.itemFormView?.isEditing = item != nil ? true : false
        self.itemFormView?.managedItemId = item?.objectID
        
        self.itemFormView?.dateLabel?.text = date?.stringForDate()
    }
    
    private func saveImage (image: UIImage?, path: String ){
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
    
    @IBAction func didSelectDone(_ sender: Any) {
        guard let title: String = self.itemFormView?.titleTextField?.text,
            let alertOn: Bool = self.itemFormView?.alertSwitcher?.isOn,
            let date: Date = self.itemFormView?.datePicker?.date else {
                return
        }
        let image: UIImage? = self.itemFormView?.imageView?.image
        let iconName: String? = self.itemFormView?.selectedIconName
        
        if self.itemFormView?.isEditing == true {
            guard let id = self.itemFormView?.managedItemId else {
                print("No id found for managed object")
                return
            }
            
            self.editItem(id: id, title: title, date: date, image: image, alertOn: alertOn, iconName: iconName)
        } else {
            self.saveItem(title: title, date: date, image: image, alertOn: alertOn, iconName: iconName)
        }
    }
    
    // MARK: - ItemForm Delegate Methods
    
    func editItem(id: NSManagedObjectID, title: String, date: Date, image: UIImage?, alertOn: Bool, iconName: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let managedObject = try managedContext.existingObject(with: id)
            managedObject.setValue(title, forKey: "title")
            managedObject.setValue(date, forKeyPath: "date")
            managedObject.setValue(iconName, forKey: "iconName")
            self.saveImage(image: image, path:title )
            
            // if it was off but is now on, add a new alert.
            if (self.itemFormView?.initialAlertState == false) && (alertOn == true) {
                localNotificationService.createNewLocalNotification(forManagedObject: managedObject, title: title, date: date)
            }
            
            // if it was on but is now off, remove the existing alert.
            if (self.itemFormView?.initialAlertState == true) && (alertOn == false) {
                localNotificationService.removeLocalNotification(withIdentifier: "UYLLocalNotification" + title, managedObject: managedObject)
                managedObject.setValue(false, forKey: "notificationActive")
            }
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        // TODO: Show the correctly changed state on the previous view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveItem(title: String, date: Date, image: UIImage?, alertOn: Bool, iconName: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Make a request to the core data database
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        
        item.setValue(title, forKeyPath: "title")
        item.setValue(date, forKeyPath: "date")
        item.setValue(iconName, forKey: "iconName")
        item.setValue(false, forKey: "notificationActive")
        
        if alertOn {
            localNotificationService.createNewLocalNotification(forManagedObject: item, title: title, date: date)
        }
        
        self.saveImage(image: image, path:title )
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        _ = self.navigationController?.popViewController(animated: true)
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
            
            imageView.contentMode = .center
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
