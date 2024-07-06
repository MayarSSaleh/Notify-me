//
//  Notifiaction.swift
//  Notify me
//
//  Created by mayar on 06/07/2024.
//

import Foundation



class Notifiaction{
    
    var title:String
    var content:String
    var repeatNotification:Bool? = false
    var time:Bool?
    var location:Bool?
    var locationName:String?
    var afterTime:String?
    var atTimeAndDat : String?
     
    init(title: String, content: String, repeatNotification: Bool? = nil, time: Bool? = nil, location: Bool? = nil, locationName: String? = nil, afterTime: String? = nil, atTimeAndDat: String? = nil) {
        self.title = title
        self.content = content
        self.repeatNotification = repeatNotification
        self.time = time
        self.location = location
        self.locationName = locationName
        self.afterTime = afterTime
        self.atTimeAndDat = atTimeAndDat
    }
    
}
