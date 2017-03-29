//
//  ViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 14/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import UIKit
import CoreData

protocol ItemViewCellDelegate {
    func deleteItemFromMemory(cell: UITableViewCell)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var itemTableView: UITableView!
    var items: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Items"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAndReloadItems()
    }
    
    fileprivate func fetchAndReloadItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        do {
            self.items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.itemTableView.reloadData()
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let tempDirectory = NSTemporaryDirectory()
        let imagePath = ("\(tempDirectory)\(path).png")
        let image = UIImage(contentsOfFile: imagePath)
        if image == nil {
            print("missing image at: \(imagePath)")
        }
        return image
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemViewCell
        cell.delegate = self
        
        let item = self.items[indexPath.row]
        guard let title = item.value(forKeyPath: "title") as? String else {
            return UITableViewCell()
        }
        
        guard let countDownString = item.value(forKeyPath: "countDown") as? String else {
            return UITableViewCell()
        }
        
        guard let iconName = item.value(forKeyPath: "iconName") as? String else {
            return UITableViewCell()
        }
        
        let backgroundImage = self.loadImageFromPath(path: title)
        
        cell.titleLabel?.text = title
        cell.dateLabel?.text = item.value(forKeyPath: "dateString") as? String
        cell.countdownLabel?.text = countDownString
        let iconColour = backgroundImage == nil ? "grey" : "white"
        let icon = UIImage(named: iconName + "-" + iconColour)
        cell.iconView?.image = icon
        cell.backgroundView = UIImageView.init(image: backgroundImage)
        cell.backgroundView?.contentMode = .scaleAspectFill
        cell.backgroundView?.alpha = 0.4
    
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension ViewController: ItemViewCellDelegate {
    
    func deleteItemFromMemory(cell: UITableViewCell) {
        guard let index  = self.itemTableView .indexPath(for: cell) else { return }
        let row = index.row
        let item = self.items[row]
        
        let context = item.managedObjectContext
        context?.delete(item)
        do {
            try context?.save()
        } catch let error as NSError {
            print("Couldn't save context. \(error.userInfo)")
        }

        self.fetchAndReloadItems()
    }
}

class ItemViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var iconView: UIImageView?
    
    var delegate: ItemViewCellDelegate?
    
    @IBAction func didDeleteEvent(_ sender: UIButton) {
        self.delegate?.deleteItemFromMemory(cell: self)
    }
    
}


