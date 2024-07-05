//
//  ViewController.swift
//  Notify me
//
//  Created by mayar on 04/07/2024.
//

import UIKit
import UserNotifications
import CoreLocation

// make 3 options
    // + sign
    // notification by intervaol
    // notifaction by time ... chosse from the calender time with repeating
    // notifiy by location ... by map and distance from this location check the internet example
    // show list by notification in the main screen may save it by realem
    // delete , update option?


class ViewController: UIViewController, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNotificationCenter.delegate = self
        self.locationManager.delegate = self
        
        self.requestNotificationAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
         
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
   
        print("clicked at add insert")
        let alert = UIAlertController(title: "Choose Notification Type", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "By Location", style: .default, handler: { _ in
            self.navigateToLocationViewModel()
        }))
        
        alert.addAction(UIAlertAction(title: "After a while", style: .default, handler: { _ in
            self.navigateToIntervalViewModel()
        }))
        
        alert.addAction(UIAlertAction(title: "At specific Time", style: .default, handler: { _ in
            self.navigateToCalenderViewModel()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func navigateToIntervalViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeIntervalViewController") as? TimeIntervalViewController{
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
      }
      
      func navigateToCalenderViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let vc = storyboard.instantiateViewController(withIdentifier: "CalenderViewController") as? CalenderViewController{
              vc.modalPresentationStyle = .fullScreen
              present(vc, animated: true, completion: nil)
          }
      }
      
      func navigateToLocationViewModel() {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController{
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
      }
      
//    func resetBadgeCount() {
//           UIApplication.shared.applicationIconBadgeNumber = 0
//           UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//       }
}
