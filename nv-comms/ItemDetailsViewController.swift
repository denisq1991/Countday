//
//  ItemDetailsViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 25/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItemDetailsViewController: UIViewController {
    
    var item: NSManagedObject?
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var alarmView: UIImageView!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var daysToGoLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        guard let title = self.item?.value(forKeyPath: "title") as? String else {
            print("Couldn't find a title for this item")
            return
        }
        self.title =  title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let date = self.item?.value(forKeyPath: "date") as? Date,
            let customNavigationController = self.navigationController as? CustomNavigationController,
            let alarmActive = self.item?.value(forKeyPath: "notificationActive") as? Bool,
            let iconName = self.item?.value(forKeyPath: "iconName") as? String else {
                return
        }
        
        if let image = self.title?.loadImageFromPath() {
            self.imageBackground.image = image
            customNavigationController.setNavBar(theme: .light)
        } else {
            self.daysToGoLabel.textColor = UIColor.black
            self.daysLeft.textColor = UIColor.black
            customNavigationController.setNavBar(theme: .lightBlackText)
        }
        
        let alarmColour = alarmActive ? "-yellow" : "-white"
        self.alarmView.image = UIImage(named: "bell" + alarmColour)
        self.iconView.image = UIImage(named: iconName + "-white")
        self.daysToGoLabel.text = date.daysFromToday().range(of:"-") != nil ? "days ago" : "days to go!"
        self.daysLeft.text = date.daysFromToday().replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemFormViewController = segue.destination as! ItemFormViewController
        itemFormViewController.currentItem = self.item
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.imageBackground.image = nil
    }
    
}
