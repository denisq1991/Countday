//
//  IconChooserViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 28/03/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

class IconChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var iconChoiceTableView: UITableView?
    
    let icons = [("bag", #imageLiteral(resourceName: "bag")),
                 ("cake", #imageLiteral(resourceName: "cake")),
                 ("car", #imageLiteral(resourceName: "car")),
                 ("diamond", #imageLiteral(resourceName: "diamond")),
                 ("giftbox", #imageLiteral(resourceName: "giftbox")),
                 ("graduate", #imageLiteral(resourceName: "graduate")),
                 ("hospital", #imageLiteral(resourceName: "hospital")),
                 ("music", #imageLiteral(resourceName: "music")),
                 ("paw", #imageLiteral(resourceName: "paw")),
                 ("plane", #imageLiteral(resourceName: "plane")),
                 ("trophy", #imageLiteral(resourceName: "trophy"))] as [(String, UIImage)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iconChoiceTableView?.separatorColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconChoiceCell", for: indexPath) as! IconChoiceCell
        let eventType = icons[indexPath.row] as (name: String, image: UIImage)
        cell.nameLabel?.text = eventType.name
        cell.iconView?.image = eventType.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

class IconChoiceCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var iconView: UIImageView?
}
