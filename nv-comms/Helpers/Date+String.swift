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
    
    func daysFromToday() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents(Set(arrayLiteral: .day, .hour), from: currentDate, to: self)
        return String(describing: components.day! + 1)
    }
    
    func dayOfWeek() -> String? {
        let dayOfTheWeekArray: [String] = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        guard let index = Calendar.current.dateComponents([.weekday], from: self).weekday else { return nil }
        return dayOfTheWeekArray[index]
    }
}
