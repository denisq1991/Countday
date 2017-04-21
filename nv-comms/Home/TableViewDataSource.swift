//
//  TableViewDataSource.swift
//  nv-comms
//
//  Created by Denis Quaid on 21/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemViewCell
        cell.delegate = self
        
        let item = self.items[indexPath.row]
        guard let countDownInt = item.value(forKeyPath: "countDown") as? Int,
            let dateString = item.value(forKeyPath: "dateString") as? String,
            let title = item.value(forKeyPath: "title") as? String else {
                return UITableViewCell()
        }
        
        let backgroundImage = title.loadImageFromPath()
        
        cell.titleLabel?.text = title
        cell.dateLabel?.text = dateString
        cell.countdownLabel?.text = String(countDownInt)
        if let iconName = item.value(forKeyPath: "iconName") as? String {
            let iconColorString = backgroundImage != nil ? "-white" : "-grey"
            cell.iconView?.image = UIImage(named: iconName + iconColorString)
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
