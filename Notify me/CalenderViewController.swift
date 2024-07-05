//
//  CalenderViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications

class CalenderViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.userNotificationCenter.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    //    func sendNotificationByTime() {
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = "Time Notification"
//        notificationContent.body = "This is a test notification scheduled by time."
//        notificationContent.badge = NSNumber(value: 1)
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 9
//        dateComponents.minute = 0
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: "timeNotification", content: notificationContent, trigger: trigger)
//        
//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//    }

}
