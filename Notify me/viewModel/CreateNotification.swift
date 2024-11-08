//
//  CreateNotification.swift
//  Notify me
//
//  Created by mayar on 06/07/2024.
//

import Foundation


class CreateNotificationViewModel {
    
    func saveNotification(title: String, notificationIdentifier:String, content: String, repeatNotification: Bool, isNotificationByTime: Bool?, isNocationByLocation: Bool?,showingMessangeAfterTime:String?,createdDate:Date? , locationName: String?, afterTime: Int?, atTimeAndDate: String?) {
        
        let notification = NotificationObject()
        notification.title = title
        notification.content = content
        notification.notificationIdentifier = notificationIdentifier
        notification.repeatNotification = repeatNotification
        notification.isNotificationByTime = isNotificationByTime
        notification.isNocationByLocation = isNocationByLocation
        notification.locationName = locationName
        notification.afterTime = afterTime
        notification.atTimeAndDate = atTimeAndDate
        notification.createdDate = createdDate
        notification.showingMessangeAfterTime = showingMessangeAfterTime
        
        print("notificaiotn in save notification\(notification)" )
        
        LocalDataBase.shared.store(notification: notification)
    }
    
}
