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
    @IBOutlet weak var daysLeft: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        guard let date = self.item?.value(forKeyPath: "date") as? Date,
            let iconName = self.item?.value(forKeyPath: "iconName") as? String,
            let title = self.item?.value(forKeyPath: "title") as? String else {
                return
        }
        
        // TODO: If a notification is set, show some kind of icon representing that
        
        self.title =  title
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let image = title.loadImageFromPath()
        self.imageBackground.image = image
        self.iconView.image = UIImage(named: iconName + "-white")
        self.daysLeft.text = date.daysFromToday()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemFormViewController = segue.destination as! ItemFormViewController
        itemFormViewController.currentItem = self.item
    }
    
}
