//
//  storedNotificationViewContrroll.swift
//  Notify me
//
//  Created by mayar on 13/07/2024.
//

import Foundation
import RealmSwift


class StoredNotificationViewModel {
    
    var notifications: Results<NotificationObject>?
    
  
    var OldNotificationsReady: (() -> Void)?
    var oldNotifications :  [NotificationObject] = []
    func fetcholdNotifications() {
        do {
            let realm = try Realm()
            notifications = realm.objects(NotificationObject.self)
            showOldNotifications()
            OldNotificationsReady?()
        } catch let error {
            print("Failed to fetch notifications from Realm: \(error)")
        }
    }

    
 
    var upComingNotifications: [NotificationObject] = []
    var upComingNotificationPreparation: (() -> Void)?
    
    func fetchUpComingNotifications() {
        do {
            let realm = try Realm()
            notifications = realm.objects(NotificationObject.self)
            
            showUpcoming()
            upComingNotificationPreparation?()
        } catch let error {
            print("Failed to fetch notifications from Realm: \(error)")
        }
    }
    
    
  
    private func showUpcoming() {
        upComingNotifications.removeAll()
        for notification in notifications! {
                print(" in show up coming function notification.isDone == \(notification.isDone) ")
                if notification.isDone == false{
                    upComingNotifications.append(notification)
                }
            
//            let now = Date()
//                if let atTimeAndDateStr = notification.atTimeAndDate,
//                   let atTimeAndDate = DateFormating.parseDate(from: atTimeAndDateStr),
//                   atTimeAndDate > now {
//                    upComingNotifications.append(notification)
//                } else if let afterTime = notification.afterTime,
//                          let createdDate = notification.createdDate {
//                    if createdDate.addingTimeInterval(TimeInterval(afterTime * 60)) > now {
//                        upComingNotifications.append(notification)
//                    }
//                }
            
        }
    }
    
    private func showOldNotifications() {
        oldNotifications.removeAll()
        
        for notification in notifications! {
             // check if done or not which changed when the user interact with the notification
                if notification.isDone == true{
                oldNotifications.append(notification)
                }
                
//                let now = Date()
//                if let atTimeAndDateStr = notification.atTimeAndDate,
//                   let atTimeAndDate = DateFormating.parseDate(from: atTimeAndDateStr),
//                   atTimeAndDate < now {
//                    oldNotifications.append(notification)
//                } else if let afterTime = notification.afterTime,
//                          let createdDate = notification.createdDate {
//                    if createdDate.addingTimeInterval(TimeInterval(afterTime * 60)) < now {
//                        oldNotifications.append(notification)
//                    }
//                }
            
        }
      //  upComingNotificationPreparation?()
    }

    func deleteUpComingNotification(at index: Int) {
        guard index < upComingNotifications.count else { return }
        let notificationToDelete = upComingNotifications[index]
        
        do {
            let realm = try Realm()
            try realm.write {
                cancelPendingNotification(identifier: notificationToDelete.notificationIdentifier)
                realm.delete(notificationToDelete)
            }
            upComingNotifications.remove(at: index)
            upComingNotificationPreparation?()
        } catch let error {
            print("Failed to delete notification from Realm: \(error)")
        }
    }

    
    func deleteNotificationFromHistory(at index: Int) {
        guard index < oldNotifications.count else { return }
        let notificationToDelete = oldNotifications[index]
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(notificationToDelete)
            }
            oldNotifications.remove(at: index)
            OldNotificationsReady?()
        } catch let error {
            print("Failed to delete notification from Realm: \(error)")
        }
    }

    private func cancelPendingNotification(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Pending notification with identifier \(identifier) has been canceled.")
    }
}
