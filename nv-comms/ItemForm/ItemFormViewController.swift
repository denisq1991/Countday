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
    func saveItem(title: String, date: Date, image: UIImage?, countDown: String, alertOn: Bool, iconName: String?)
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
    let imagePath:  String? = nil
    var currentItem: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.currentItem != nil ? "Edit An Item" : "Create New Item"
        self.setUpItemForm(item: self.currentItem)
        self.itemFormView?.delegate = self
        self.imagePicker = UIImagePickerController()
    }
    
    private func setUpItemForm(item: NSManagedObject?) {
        self.itemFormView?.datePicker?.date = Date()
        self.itemFormView?.imageView?.contentMode = .center
        self.itemFormView?.imageView?.contentMode = .scaleAspectFill
        self.itemFormView?.imageView?.clipsToBounds = true
        
        let dateString = item?.value(forKeyPath: "dateString") as? String
        let title = item?.value(forKeyPath: "title") as? String
        self.itemFormView?.titleTextField?.text = title ?? ""
        self.itemFormView?.imageView?.image = title?.loadImageFromPath()
        self.itemFormView?.alertSwitcher?.isOn = false
        if let iconName = item?.value(forKeyPath: "iconName") as? String {
            self.itemFormView?.selectedIconName = iconName
            self.itemFormView?.selectedIconView?.image = UIImage(named: iconName + "-grey")
        } else {
            self.itemFormView?.selectedIconName = ""
        }
        self.itemFormView?.isEditing = item != nil ? true : false
        self.itemFormView?.managedItemId = item?.objectID
        
        self.itemFormView?.dateLabel?.text = dateString ?? self.itemFormView?.datePicker?.date.stringForDate()
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
    
    private func setLocalNotification(text: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Countday Alert"
        content.body = text
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "UYLLocalNotification" + text
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
        })
    }
    
    @IBAction func didSelectDone(_ sender: Any) {
        guard let title: String = self.itemFormView?.titleTextField?.text,
            let date: Date = self.itemFormView?.datePicker?.date else {
                return
        }
        
        // Get the days between both dates
        // TODO: Handle negatives gracefully
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents(Set(arrayLiteral: .day, .hour), from: currentDate, to: date)
        
        let days = String(describing: components.day!)
        
        let image: UIImage? = self.itemFormView?.imageView?.image
        let iconName: String? = self.itemFormView?.selectedIconName
        guard let alertOn: Bool = self.itemFormView?.alertSwitcher?.isOn else {
            return
        }
        
        if self.itemFormView?.isEditing == true {
            guard let id = self.itemFormView?.managedItemId else {
                print("No id found for managed object")
                return
            }
            
            self.editItem(id: id, title: title, date: date, image: image, countDown: days, alertOn: alertOn, iconName: iconName)
        } else {
            self.saveItem(title: title, date: date, image: image, countDown: days, alertOn: alertOn, iconName: iconName)
        }
    }
    
    // MARK: - ItemForm Delegate Methods
    
    func editItem(id: NSManagedObjectID, title: String, date: Date, image: UIImage?, countDown: String, alertOn: Bool, iconName: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Make a request to the core data database
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let managedObject = try managedContext.existingObject(with: id)
            let dateString = date.stringForDate()
            managedObject.setValue(title, forKey: "title")
            managedObject.setValue(dateString, forKeyPath: "dateString")
            managedObject.setValue(Int(countDown), forKey: "countDown")
            managedObject.setValue(iconName, forKey: "iconName")
            self.saveImage(image: image, path:title )
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveItem(title: String, date: Date, image: UIImage?, countDown: String, alertOn: Bool, iconName: String?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Make a request to the core data database
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let dateString = date.stringForDate()
        item.setValue(title, forKeyPath: "title")
        item.setValue(dateString, forKeyPath: "dateString")
        item.setValue(Int(countDown), forKey: "countDown")
        item.setValue(iconName, forKey: "iconName")
        
        if (alertOn) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                    // TODO: Alert the user and link them to change the setting
                }
                else {
                    self.setLocalNotification(text: title, date: date)
                }
            }
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
