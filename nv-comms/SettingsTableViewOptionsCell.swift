//
//  SettingsTableViewOptionsCell.swift
//  nv-comms
//
//  Created by teamwork.com on 17/08/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewOptionsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var timeSelector: UIDatePicker?
    @IBOutlet weak var timeSelectorContainerView: UIView?
    @IBOutlet weak var timeSelectorViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let defaultTime = UserDefaults.standard.value(forKey: defaultAlarmTimeKey) as? Date
        self.timeLabel?.text = dateFormatter.string(from: defaultTime!)
        self.timeSelectorViewHeight.constant = 0
        self.timeSelector?.addTarget(self, action: #selector(timeSelectorChanged), for: .valueChanged)
    }
    
    
    @objc private func timeSelectorChanged() {
        guard let selectedTime = self.timeSelector?.date else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let timeComponents = NSCalendar.current.dateComponents([.hour, .minute, .second], from: selectedTime)
        let isolatedTime = NSCalendar.current.date(from: timeComponents)
        
        UserDefaults.standard.set(isolatedTime, forKey: defaultAlarmTimeKey)
        self.timeLabel?.text = dateFormatter.string(from: selectedTime)
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        // if the time set for the defaultAlarmTime key is different to what it was when settings was opened
        
        // get all the current "items" from the NSManagedObject
        
        // Loop through each of them
        
        // If the alarm is set on
        
        // change from the previous alarm time to this new time
    }
    
}

