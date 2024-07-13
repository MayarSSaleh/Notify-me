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
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
             
            })
        
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        
        self.notificationCenter.delegate = self
        return true
    }
    
    
    private func application(_ application: UIApplication, didReceive notification: UNNotificationRequest) {
        // i do not show badge
//        UIApplication.shared.applicationIconBadgeNumber = 0
        print ( " interact in background?")

    }

 
}

//Handle incoming notifications while app is in foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Handle incoming notifications while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(" app in for ground in app delegete to show it")
        completionHandler([.banner, .sound])
    }
    
    
// Handle notification interaction when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print ( " interact in for ground?")
        let userInfo = response.notification.request.content.userInfo

        
//        if let notificationID = userInfo["notificationID"] as? String {
//            print(" find the primary key")
//              do {
//                  let realm = try Realm()
//                  if let notification = realm.object(ofType: NotificationObject.self, forPrimaryKey: notificationID) {
//                      try realm.write {
//                          print( " notification.isDone  \(notification.isDone ) " )
//                          notification.isDone = true
//                          print( " notification.isDone  \(notification.isDone ) " )
//
//                      }
//                  }
//              } catch let error {
//                  print("Failed to update notification in Realm: \(error)")
//              }
//          }
          
        
        let title = userInfo["title"] as? String ?? "No Title"
        let content = userInfo["body"] as? String ?? "No body"

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
            vc.notificationTitle = title
            vc.notificationContent = content
            vc.modalPresentationStyle = .fullScreen
        // Present the view controller
             if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                 rootVC.present(vc, animated: true, completion: nil)
             }else {
                 print("enter else")
             }
        completionHandler()
        
        
    }
}
