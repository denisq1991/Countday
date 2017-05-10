
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
    case options
}


class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    var currentlySelectedRow: Int?
    let settingsItems: [(String, SettingsItem)] = [("Sort By Date Ascending", .toggle),
                                                   ("Default Alarm Time", .options)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.settingsTableView.tableFooterView = UIView()
        
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
        
        switch item.type {
        case .toggle:
            self.settingsTableView.register(UINib(nibName: "SettingsTableViewToggleCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewToggleCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewToggleCell", for: indexPath) as! SettingsTableViewToggleCell
            cell.titleLabel?.text = item.title
            if let toggleState = UserDefaults.standard.value(forKey: item.title) as? Bool {
                cell.toggle?.isOn = toggleState
            }
            cell.selectionStyle = .none
            return cell
        case .options :
            self.settingsTableView.register(UINib(nibName: "SettingsTableViewOptionsCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewOptionsCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewOptionsCell", for: indexPath) as! SettingsTableViewOptionsCell
            cell.titleLabel?.text = item.title
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let optionsCell = self.settingsTableView.cellForRow(at: indexPath) as? SettingsTableViewOptionsCell else {
            return
        }
        self.currentlySelectedRow = optionsCell.timeSelectorViewHeight.constant > 0 ? nil : indexPath.row
        self.toggleCellHeight(cell: optionsCell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        // if this row is the same as the row we've just selected, toggle the height
        if row == self.currentlySelectedRow {
            return 200
        }
        return 50
    }
    
    private func toggleCellHeight(cell: SettingsTableViewOptionsCell) {
        if cell.timeSelector != nil {
            let newHeight = cell.timeSelectorViewHeight.constant > 0 ? 0 : 140
            cell.timeSelectorViewHeight.constant = CGFloat(newHeight)
            self.settingsTableView.reloadData()
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

class SettingsTableViewOptionsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var timeSelector: UIDatePicker?
    @IBOutlet weak var timeSelectorContainerView: UIView?
    @IBOutlet weak var timeSelectorViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeLabel?.text = "12:00pm"
        self.timeSelectorViewHeight.constant = 0
    }
}




