//
//  LocalDataBase.swift
//  Notify me
//
//  Created by mayar on 07/11/2024.
//

import Foundation
import RealmSwift

class LocalDataBase {
    
    private let realm: Realm
    
    static let shared = LocalDataBase()
    
    private init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func fetchNotifications() -> Results<NotificationObject>? {
        return realm.objects(NotificationObject.self)
    }
    
    func store(notification: NotificationObject) {
        try! realm.write {
            realm.add(notification)
        }
    }
    
    func deleteNotification(_ notification: NotificationObject) {
        try! realm.write {
            realm.delete(notification)
        }
    }
    
    func cancelPendingNotification(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Pending notification with identifier \(identifier) has been canceled.")
    }
}
