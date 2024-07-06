//
//  ViewController.swift
//  Notify me
//
//  Created by mayar on 04/07/2024.
//

import UIKit
import UserNotifications

// make 3 options
    // + sign
    // notification by intervaol
    // notifaction by time ... chosse from the calender time with repeating
    // notifiy by location ... by map and distance from this location check the internet example
    // show list by notification in the main screen may save it by realem
    // delete , update option?


class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestNotificationAuthorization()
    }
    
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                Alert.showAlert(title: "without permisiion the notification will not appear", uiView: self)
                print("Error: ", error)
            }
        
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Notification Type", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "At Time", style: .default, handler: { _ in
            self.navigateToCalenderViewModel()
        }))
        alert.addAction(UIAlertAction(title: "At Location", style: .default, handler: { _ in
            self.navigateToLocationViewModel()
        }))
        alert.addAction(UIAlertAction(title: "After a while", style: .default, handler: { _ in
            self.navigateToIntervalViewModel()
        }))
    
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func navigateToIntervalViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController{
            vc.comeAsTimeInterval = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
      }
      
      func navigateToCalenderViewModel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController{
              vc.comeAsTimeInterval = false
              vc.modalPresentationStyle = .fullScreen
              present(vc, animated: true, completion: nil)
          }
      }
      
      func navigateToLocationViewModel() {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController{
                vc.comeAsMap = true
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
      }
  
}
