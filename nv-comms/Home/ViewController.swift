//
//  ViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 14/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import UIKit
import CoreData
import Koloda

protocol ItemViewCellDelegate {
    func deleteItemFromMemory(cell: UITableViewCell)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var OnboardingMessage: UILabel!
    
    // a sorted array of items
    var items: [NSManagedObject] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.countOfVisibleCards = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchAndReloadItems()
        self.kolodaView.reloadData()
        if let customNavigationContoller = self.navigationController as? CustomNavigationController {
            customNavigationContoller.setNavBar(theme: self.items.count > 0 ? .light : .lightBlackText)
        }
    }
    
    fileprivate func fetchAndReloadItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        if let toggleState = UserDefaults.standard.value(forKey: "Sort By Date Ascending") as? Bool {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: toggleState)]
        }
        
        do {
            self.items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.OnboardingMessage.isHidden = self.items.count > 0 ? true : false
        self.itemTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.itemTableView.indexPathForSelectedRow else {
            return
        }
        
        let itemDetailsViewController = segue.destination as! ItemDetailsViewController
        itemDetailsViewController.item = self.items[indexPath.row]
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
        self.kolodaView.reloadData()
    }
}



class ItemViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var iconView: UIImageView?
    
    var delegate: ItemViewCellDelegate?
    
}
