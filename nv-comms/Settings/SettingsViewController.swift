
//
//  SettingsViewController.swift
//  nv-comms
//
//  Created by Denis Quaid on 19/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

typealias SettingsCellItem = (key: String, title: String, type: SettingsItem)
let defaultAlarmTimeKey = "defaultAlarmTime"

enum SettingsItem {
    case toggle
    case options
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    var currentlySelectedRow: Int?
    let settingsItems: [(String, String, SettingsItem)] = [("sortByDate", "Sort By Date Ascending", .toggle),
                                                   ("defaultAlarmTime", "Default Alarm Time", .options),
                                                   ("dynamicEventsTable", "Dynamic Events Table", .toggle),
                                                   ("showEventsForecast", "Show Event Forecast", .toggle)
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
        let item: SettingsCellItem = self.settingsItems[indexPath.row]
        return self.cellForItem(item: item, indexPath: indexPath, tableView: tableView)
    }
    
    private func cellForItem(item: SettingsCellItem, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch item.type {
        case .toggle:
            self.settingsTableView.register(UINib(nibName: "SettingsTableViewToggleCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewToggleCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewToggleCell", for: indexPath) as! SettingsTableViewToggleCell
            cell.titleLabel?.text = item.title
            cell.key = item.key
            if let toggleState = UserDefaults.standard.value(forKey: item.key) as? Bool {
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



