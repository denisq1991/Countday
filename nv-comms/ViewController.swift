//
//  ViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 14/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import UIKit
import CoreData

protocol UserViewCellDelegate {
    func deleteUserFromMemory(cell: UITableViewCell)
}

class ViewController: UIViewController, UserFormDelegate {
    
    @IBOutlet weak var userTableView: UITableView!
    var users: [NSManagedObject] = []
    
    @IBOutlet weak var userFormView: UserFormView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        self.userFormView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userFormView?.isHidden = true
        self.fetchAndReloadUsers()
    }
    
    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        self.userFormView?.isHidden = false
    }
    
    fileprivate func fetchAndReloadUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            self.users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.userTableView.reloadData()
    }
    
    func saveUser(name: String, email: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(name, forKeyPath: "name")
        user.setValue(email, forKeyPath: "emailAddress")
        
        do {
            try managedContext.save()
            self.users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.fetchAndReloadUsers()
        self.userFormView?.isHidden = true
    }
    
    func presentViewController(imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserViewCell
        cell.delegate = self
        
        let user = self.users[indexPath.row]
        cell.nameLabel?.text = user.value(forKeyPath: "name") as? String
        cell.emailLabel?.text = user.value(forKeyPath: "emailAddress") as? String
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension ViewController: UserViewCellDelegate {
    
    func deleteUserFromMemory(cell: UITableViewCell) {
        guard let index  = self.userTableView .indexPath(for: cell) else { return }
        let row = index.row
        let item = self.users[row]
        
        let context = item.managedObjectContext
        context?.delete(item)
        self.fetchAndReloadUsers()
    }
}

class UserViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    var delegate: UserViewCellDelegate?
    
    @IBAction func deleteUser(_ sender: UIButton) {
        self.delegate?.deleteUserFromMemory(cell: self)
    }
    
}


