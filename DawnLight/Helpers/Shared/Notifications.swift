//
//  Global.swift
//  IncGame
//
//  Created by Martin Václavík on 10/11/2020.
//

import Foundation
import UserNotifications

struct NotificationController {
    static func requestNotificationsPermission(options: UNAuthorizationOptions){
        //Request Notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if success {
                print("Notification permissions granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    ///Requests a permission to send Notifications and sets a new notification
    ///- Parameter time: TimeInterval to display Notification.
    ///- Parameter title: Notification Title.
    ///- Parameter subtitle: Notification text/subtitle
    ///- Parameter repeats: Repeat notification
    ///- Parameter uuid: Notification UUID
    static func requestNotification(time:TimeInterval, title:String, subtitle:String, uuid: String, repeats:Bool = false){
        //Request Notification permission
        requestNotificationsPermission(options: [.alert, .badge, .sound])
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = subtitle
            
            if settings.alertSetting == .enabled {
                // Schedule an alert-only notification.
            } else {
                content.sound = UNNotificationSound.default
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: repeats)
            
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            
            //Pokud už existuje notifikace s daným ID, smažu jí a vytvořím znovu.
            deleteNotification(identifiers: [uuid])
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    ///Removes pending notifications from queue based on identifiers
    ///- Parameter identifiers: Array of identifiers
    static func deleteNotification(identifiers: [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
