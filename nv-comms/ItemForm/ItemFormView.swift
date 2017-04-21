//
//  ItemFormView.swift
//  nv-comms
//
//  Created by Denis Quaid on 12/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItemFormView : UIView {
    
    @IBOutlet var titleTextField: UITextField?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var datePickerExpandView: UIView?
    @IBOutlet var datePicker: UIDatePicker?
    @IBOutlet var datePickerViewHeight: NSLayoutConstraint?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var alertSwitcher: UISwitch?
    @IBOutlet var selectedIconView: UIImageView?
    
    var selectedIconName: String?
    
    var isEditing = false
    var managedItemId: NSManagedObjectID?
    
    var delegate: ItemFormDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.datePickerViewHeight?.constant = CGFloat(0)
        self.datePicker?.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        if !self.isEditing {
            self.resetFormState()
        } else {

        }
    }
    
    private func resetFormState() {
        self.datePicker?.date = Date()
        self.titleTextField?.text = ""
        self.imageView?.image = nil
        self.alertSwitcher?.isOn = false
        self.selectedIconName = ""
        let dateString = self.datePicker?.date.stringForDate()
        self.dateLabel?.text = dateString
    }
    
    
    @IBAction func didSelectDatePicker() {
        // toggle the constraints of the datePickerView
        let isCollapsed = self.datePickerViewHeight?.constant == CGFloat(0)
        // TODO: Animate this
        self.datePickerViewHeight?.constant = isCollapsed ? CGFloat(216) : CGFloat(0)
    }
    
    @objc func datePickerChanged() {
        let newDate = self.datePicker?.date
        let dateString = newDate?.stringForDate()
        self.dateLabel?.text = dateString
    }
    
    @IBAction func addNewImage(sender: Any) {
        self.delegate?.addNewImage()
    }
    
}
