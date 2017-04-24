//
//  TableviewDelegate.swift
//  nv-comms
//
//  Created by Denis Quaid on 21/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            self.deleteItemFromMemory(cell: cell)
            tableView.reloadData()
        }
        
    }
    
}
