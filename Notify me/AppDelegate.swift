//
//  AppDelegate.swift
//  Notify me
//
//  Created by mayar on 04/07/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    
//AppDelegate: Handles the notification response when the app is in the background or terminated. Sets the root view controller and navigates to the NotificationDetailViewController.
    // Handle notification response when the app is in background or terminated
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         let userInfo = response.notification.request.content.userInfo
         
         // Ensure your main view controller is loaded
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let initialViewController = storyboard.instantiateViewController(withIdentifier: "TimeIntervalViewController") as! TimeIntervalViewController
         let navController = UINavigationController(rootViewController: initialViewController)

         // Pass the notification data to the view controller
         if let notificationDetailVC = storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as? NotificationDetailViewController {
             notificationDetailVC.notificationTitle = response.notification.request.content.title
             notificationDetailVC.notificationContent = response.notification.request.content.body
             navController.pushViewController(notificationDetailVC, animated: false)
         }else {
             print(" in app deleget ")
         }

         window?.rootViewController = navController
         window?.makeKeyAndVisible()

         completionHandler()
     }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

