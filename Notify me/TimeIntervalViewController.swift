//
//  TimeIntervalViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications

class TimeIntervalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print( " TimeIntervalViewController")
        
  //      self.userNotificationCenter.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //    func sendNotificationByInterval() {
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = "Interval Notification"
//        notificationContent.body = "This is a test notification sent by interval."
//        notificationContent.badge = NSNumber(value: 1)
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//        let request = UNNotificationRequest(identifier: "intervalNotification", content: notificationContent, trigger: trigger)
//        
//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//    }

}
