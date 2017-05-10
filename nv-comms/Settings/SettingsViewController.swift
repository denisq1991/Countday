
//
//  SettingsViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 19/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

enum SettingsItem {
    case toggle
    //case list([String])
}


class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    let settingsItems: [(String, SettingsItem)] = [("Sort By Date Ascending", .toggle)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        if let customNavigationController = self.navigationController as? CustomNavigationController {
            customNavigationController.setNavBar(theme: .lightBlackText)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: (title: String, type: SettingsItem) = self.settingsItems[indexPath.row]
        
        if (item.type == .toggle) {
            self.settingsTableView.register(UINib(nibName: "SettingsTableViewToggleCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewToggleCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewToggleCell", for: indexPath) as! SettingsTableViewToggleCell
            cell.titleLabel?.text = item.title
            if let toggleState = UserDefaults.standard.value(forKey: item.title) as? Bool {
                cell.toggle?.isOn = toggleState
            }
            return cell
        } else {
            return UITableViewCell()
        }
 
    }
}

class SettingsTableViewToggleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var toggle: UISwitch?
    

    @IBAction func didToggleOption(_ sender: Any) {
        guard let title = titleLabel?.text else {
            print("Cell needs a title to save to user defaults!")
            return
        }
        UserDefaults.standard.set(self.toggle?.isOn, forKey: title)
    }
}




