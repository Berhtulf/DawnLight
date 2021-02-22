//
//  Global.swift
//  IncGame
//
//  Created by Martin Václavík on 10/11/2020.
//

import Foundation
import UserNotifications

struct NotificationController {
    ///Requests a permission to send Notifications and sets a new notification
    ///- Parameter time: TimeInterval to display Notification.
    ///- Parameter title: Notification Title.
    ///- Parameter subtitle: Notification text/subtitle
    ///- Parameter repeats: Repeat notification
    ///- Parameter uuid: Notification UUID
    static func requestNotification(time:TimeInterval, title:String, subtitle:String, repeats:Bool = false, uuid: String = UUID().uuidString){
        
        //Request Notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        //Pokud už existuje notifikace s daným ID, smažu jí a vytvořím znovu.
        deleteNotification(identifiers: [uuid])
        UNUserNotificationCenter.current().add(request)
    }
    
    ///Removes pending notifications from queue based on identifiers
    ///- Parameter identifiers: Array of identifiers
    static func deleteNotification(identifiers: [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
