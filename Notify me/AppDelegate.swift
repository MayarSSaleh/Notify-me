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
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
             
            })
        
        Realm.Configuration.defaultConfiguration = config
        
        // Open the Realm with the new configuration
        let realm = try! Realm()
        
        
        self.requestNotificationAuthorization()
        self.notificationCenter.delegate = self
        return true
    }
 

    // Request notification authorization
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        self.notificationCenter.requestAuthorization(options: authOptions) { (granted, error) in
            if let error = error {
                print("Notification authorization request failed: \(error)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Handle incoming notifications while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(" app in for ground in app delegete")
        completionHandler([.banner, .sound])
    }
    
    // Handle notification interaction when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print ( " interact")
      
        let userInfo = response.notification.request.content.userInfo
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
        

        // Handle any actions triggered by the user tapping on the notification
        print("Tapped on notification while app is in foreground", userInfo)
        
        completionHandler()
    }
}
