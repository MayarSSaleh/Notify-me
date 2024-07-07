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
    @Persisted var repeatNotification: Bool = false
    @Persisted var time: Bool?
    @Persisted var location: Bool?
    @Persisted var locationName: String?
    @Persisted var afterTime: String?
    @Persisted var atTimeAndDate: String?
}
