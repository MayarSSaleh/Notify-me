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
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)

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
        
        let content = notification.request.content
        let title = content.title
        let body = content.body
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let rootViewController = self.window?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
        
        completionHandler([.banner, .sound])
    }
    
    // Handle notification interaction when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print ( " interact")
        let userInfo = response.notification.request.content.userInfo
        // Handle any actions triggered by the user tapping on the notification
        print("Tapped on notification while app is in foreground", userInfo)
        
        completionHandler()
    }
}
