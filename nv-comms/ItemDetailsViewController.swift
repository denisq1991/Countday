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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        guard let title = self.item?.value(forKeyPath: "title") as? String else {
                return
        }
        
        self.title =  title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let customNavigationController = self.navigationController as? CustomNavigationController {
            customNavigationController.setNavBar(theme: .light)
        }
        
        guard let date = self.item?.value(forKeyPath: "date") as? Date,
            let alarmActive = self.item?.value(forKeyPath: "notificationActive") as? Bool,
            let iconName = self.item?.value(forKeyPath: "iconName") as? String else {
                return
        }
        
        let image = self.title?.loadImageFromPath()
        let alarmColour = alarmActive ? "-yellow" : "-white"
        self.alarmView.image = UIImage(named: "bell" + alarmColour)
        self.imageBackground.image = image
        self.iconView.image = UIImage(named: iconName + "-white")
        if date.daysFromToday().range(of:"-") != nil{
            self.daysToGoLabel.text = "days ago"
        }
        self.daysLeft.text = date.daysFromToday().replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemFormViewController = segue.destination as! ItemFormViewController
        itemFormViewController.currentItem = self.item
    }
    
}
