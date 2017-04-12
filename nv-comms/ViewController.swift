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
    var items: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Items"
        self.fetchAndReloadItems()
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAndReloadItems()
        self.kolodaView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.itemTableView.indexPathForSelectedRow else {
            return
        }

        let itemFormViewController = segue.destination as! ItemFormViewController
        itemFormViewController.itemFormView?.isEditing = true
        itemFormViewController.currentItem = self.items[indexPath.row]
    }
}

// MARK: - Tableview Delegate & DataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemViewCell
        cell.delegate = self
        
        let item = self.items[indexPath.row]
        guard let countDownString = item.value(forKeyPath: "countDown") as? String,
            let dateString = item.value(forKeyPath: "dateString") as? String,
            let title = item.value(forKeyPath: "title") as? String else {
                return UITableViewCell()
        }
        
        let backgroundImage = title.loadImageFromPath()
        
        cell.titleLabel?.text = title
        cell.dateLabel?.text = dateString
        cell.countdownLabel?.text = countDownString
        if let iconName = item.value(forKeyPath: "iconName") as? String {
            cell.iconView?.image = UIImage(named: iconName + "-white")
        }
        
        cell.backgroundView = UIImageView.init(image: title.loadImageFromPath())
        cell.backgroundView = UIImageView.init(image: backgroundImage)
        cell.backgroundView?.isUserInteractionEnabled = false
        cell.backgroundView?.contentMode = .scaleAspectFill
        cell.backgroundView?.alpha = 0.4
        cell.selectionStyle = .none
        
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

// MARK: - Kolada Delegate & DataSource

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.kolodaView.resetCurrentCardIndex()
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }
}

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return self.items.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let item = self.items[index]
        guard let title = item.value(forKeyPath: "title") as? String else {
            return UITableViewCell()
        }
        
        guard let countDownString = item.value(forKeyPath: "countDown") as? String else {
            return UITableViewCell()
        }
        let swipeCard = Bundle.main.loadNibNamed("SwipeCardView", owner: self, options: nil)?[0] as! SwipeCardView
        guard let imageView = swipeCard.imageView,
            let daysLabel = swipeCard.daysLabel else {
                return UIView()
        }
        
        daysLabel.text = countDownString
        imageView.image = title.loadImageFromPath()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        
        return swipeCard
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
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
