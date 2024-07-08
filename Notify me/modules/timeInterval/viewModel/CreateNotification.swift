//
//  CreateNotification.swift
//  Notify me
//
//  Created by mayar on 06/07/2024.
//

import RealmSwift

class CreateNotificationViewModel {
    private var realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func saveNotification(title: String, content: String, repeatNotification: Bool, isNotificationByTime: Bool?, isNocationByLocation: Bool?, locationName: String?, afterTime: String?, atTimeAndDate: String?) {
        let notification = NotificationObject()
        notification.title = title
        notification.content = content
        notification.repeatNotification = repeatNotification
        notification.isNotificationByTime = isNotificationByTime
        notification.isNocationByLocation = isNocationByLocation
        notification.locationName = locationName
        notification.afterTime = afterTime
        notification.atTimeAndDate = atTimeAndDate

        try! realm.write {
            realm.add(notification)
        }
    }
}
