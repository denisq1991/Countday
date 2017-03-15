//
//  ViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 14/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UserFromDelegate {
    
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
        self.fetchUsers()
        self.userTableView.reloadData()
    }
    
    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        self.userFormView?.isHidden = false
    }
    
    fileprivate func fetchUsers() {
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
        
        self.fetchUsers()
        self.userTableView.reloadData()
        self.userFormView?.isHidden = true
    }
    
    func DeleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Entity"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserFormViewCell
      
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


