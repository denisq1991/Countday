//
//  SettingsTableViewToggleCell.swift
//  nv-comms
//
//  Created by teamwork.com on 17/08/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewToggleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var toggle: UISwitch?
    
    var key: String?
    
    @IBAction func didToggleOption(_ sender: Any) {
        guard let key = key else {
            print("Cell needs a key to save to user defaults!")
            return
        }
        UserDefaults.standard.set(self.toggle?.isOn, forKey: key)
    }
}
