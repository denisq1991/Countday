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
        let cellIdentifier = "ItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItemViewCell
        
        cell.delegate = self
        let item = self.items[indexPath.row]
        guard let dateString = item.value(forKeyPath: "dateString") as? String,
            let title = item.value(forKeyPath: "title") as? String else {
                return UITableViewCell()
        }
        
        guard let date = dateString.dateForString() else {
            return UITableViewCell()
        }

        cell.titleLabel?.text = title
        cell.dateLabel?.text = dateString
        cell.countdownLabel?.text = date.daysFromToday()
        if let iconName = item.value(forKeyPath: "iconName") as? String {
            cell.iconView?.image = UIImage(named: iconName + "- grey")
        }

        
        return cell
    }
}
