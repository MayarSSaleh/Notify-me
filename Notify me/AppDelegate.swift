//
//  AppDelegate.swift
//  Notify me
//
//  Created by mayar on 04/07/2024.
//


import UIKit
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
     
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

           let config = Realm.Configuration(schemaVersion: 3)
           Realm.Configuration.defaultConfiguration = config
           
           self.notificationCenter.delegate = self
           UIApplication.shared.applicationIconBadgeNumber = 0

           return true
       }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Display the notification even if the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(" app in for ground in app delegete to show it")
        completionHandler([.banner, .sound])
    }
    
// Handle notification interaction when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print ( " interact in for ground?")
        let userInfo = response.notification.request.content.userInfo
        if let notificationID = userInfo["notificationID"] as? String {
            print(" find the primary key\(notificationID)")
              do {
                  let realm = try Realm()
                  if let notification = realm.object(ofType: NotificationObject.self, forPrimaryKey: notificationID) {
                      try realm.write {
                          print( " notification.isDone before change \(notification.isDone ) " )
                          notification.isDone = true
                          print( " notification.isDone  \(notification.isDone ) " )
                      }
                  }
              } catch let error {
                  print("Failed to update notification in Realm: \(error)")
              }
          }
                
        let title = userInfo["title"] as? String ?? "No Title"
        let content = userInfo["body"] as? String ?? "No body"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
            vc.notificationTitle = title
            vc.notificationContent = content
            vc.modalPresentationStyle = .fullScreen
        
        print("show notification details ")
            
        if let rootVC = window?.rootViewController {
            rootVC.present(vc, animated: true, completion: nil)
        } else {
            print("No root view controller found.")
        }
        completionHandler()
    }
}
