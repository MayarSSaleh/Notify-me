//
//  Notifiaction.swift
//  Notify me
//
//  Created by mayar on 06/07/2024.
//

import Foundation
import RealmSwift


class NotificationObject: Object {
    @Persisted var title: String = ""
    @Persisted var content: String = ""
    @Persisted var notificationIdentifier: String = ""
    @Persisted var repeatNotification: Bool = false
    @Persisted var isNotificationByTime: Bool?
    @Persisted var isDone: Bool = false
    @Persisted var isNocationByLocation: Bool?
    @Persisted var locationName: String?
    @Persisted var afterTime: Int?
    @Persisted var createdDate: Date?
    @Persisted var showingMessangeAfterTime: String?
    @Persisted var atTimeAndDate: String?
    
    override static func primaryKey() -> String? {
         return "notificationIdentifier"
     }
}
