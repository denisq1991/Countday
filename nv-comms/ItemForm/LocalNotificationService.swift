//
//  LocalNotificationService.swift
//  nv-comms
//
//  Created by Denis Quaid on 26/04/2017.
//  Copyright © 2017 dquaid. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications


// TODO: Make this a singleton, make all the functions class functions
class LocalNotificationService {
    
    func createNewLocalNotification(forManagedObject managedObject: NSManagedObject, title: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                // TODO: Alert the user and link them to change the setting
            }
            else {
                self.setLocalNotification(text: title, date: date)
                managedObject.setValue(true, forKey: "notificationActive")
            }
            
        }
    }
    
    func removeLocalNotification(withIdentifier identifier: String, managedObject: NSManagedObject) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        managedObject.setValue(false, forKey: "notificationActive")
    }
    
    private func setLocalNotification(text: String, date: Date) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Countday Alert"
        content.body = text
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // TODO: Make this more unique so double titles won't mess it up
        let identifier = "UYLLocalNotification" + text
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
        })
    }
}
