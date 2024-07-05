//
//  MapViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import CoreLocation
import UserNotifications

class MapViewController: UIViewController , CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.userNotificationCenter.delegate = self

        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
//    func sendNotificationByLocation() {
//        let notificationContent = UNMutableNotificationContent()
//        notificationContent.title = "Location Notification"
//        notificationContent.body = "You have arrived at the specified location."
//        notificationContent.badge = NSNumber(value: 1)
//        
//        let center = CLLocationCoordinate2D(latitude: 37.335480, longitude: -121.893028)
//        let region = CLCircularRegion(center: center, radius: 100.0, identifier: "locationNotification")
//        region.notifyOnEntry = true
//        region.notifyOnExit = false
//        
//        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
//        let request = UNNotificationRequest(identifier: "locationNotification", content: notificationContent, trigger: trigger)
//        
//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//    }
//    
//    // CLLocationManagerDelegate method
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            // Authorization granted, proceed with location-related tasks
//        }
//    }
}
