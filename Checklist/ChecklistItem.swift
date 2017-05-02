//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Shree Tanna on 2016-12-10.
//  Copyright © 2016 Shree. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind" )
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }

    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // set up item content
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            //set up calender format
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            //set notification trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            //set Notification Request
            let request  =  UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            //Add notification to UNUserNotificationCenter
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled Notification \(request) for item \(itemID)")
            
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [ "\(itemID)"])
    }
    
}
