//
//  Date+String.swift
//  nv-comms
//
//  Created by Denis Quaid on 12/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation

extension Date {
    func stringForDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    
}
