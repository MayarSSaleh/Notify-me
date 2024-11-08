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
    var upComingNotifications: [NotificationObject] = []
    var upComingNotificationPreparation: (() -> Void)?
    
    
    func fetchOldNotifications() {
           notifications = LocalDataBase.shared.fetchNotifications()
           showOldNotifications()
           OldNotificationsReady?()
       }

    func fetchUpComingNotifications() {
         notifications = LocalDataBase.shared.fetchNotifications()
         showUpcomingNotifications()
         upComingNotificationPreparation?()
     }
    
    private func showUpcomingNotifications() {
        upComingNotifications.removeAll()

           upComingNotifications = notifications?.filter { !$0.isDone } ?? []
       }
       
       private func showOldNotifications() {
           oldNotifications.removeAll()
           oldNotifications = notifications?.filter { $0.isDone } ?? []
       }

    func deleteUpcomingNotification(at index: Int) {
          guard index < upComingNotifications.count else { return }
          let notificationToDelete = upComingNotifications[index]
          
          LocalDataBase.shared.cancelPendingNotification(identifier: notificationToDelete.notificationIdentifier)
          LocalDataBase.shared.deleteNotification(notificationToDelete)
          
          upComingNotifications.remove(at: index)
          upComingNotificationPreparation?()
      }
   
    func deleteNotificationFromHistory(at index: Int) {
           guard index < oldNotifications.count else { return }
           let notificationToDelete = oldNotifications[index]
           
           LocalDataBase.shared.deleteNotification(notificationToDelete)
           oldNotifications.remove(at: index)
           OldNotificationsReady?()
       }
}
