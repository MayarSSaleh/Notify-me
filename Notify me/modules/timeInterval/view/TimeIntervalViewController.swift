//
//  TimeIntervalViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications

class TimeIntervalViewController: UIViewController {
    
    @IBOutlet weak var notificationTitle: UITextField!
    @IBOutlet weak var minutesPicker: UIPickerView!
    @IBOutlet weak var contentOfNOtifiction: UITextField!
    @IBOutlet weak var add: UIButton!
    
    var repeatNotification: Bool = true
    let timeIntervals = [1,10, 20, 30, 40, 50, 60]
    let intervalLabels = ["1 minutes","10 minutes", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes"]
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNotificationCenter.delegate = self
        
        minutesPicker.dataSource = self
        minutesPicker.delegate = self
        
        add.layer.cornerRadius = 12
        minutesPicker.selectRow(3, inComponent: 0, animated: false)
    }
    
    @IBAction func repeatSwitchChanged(_ sender: UISwitch) {
        repeatNotification = sender.isOn
    }
    
    @IBAction func addNotification(_ sender: Any) {
        guard let title = notificationTitle.text, !title.isEmpty,
              let body = contentOfNOtifiction.text, !body.isEmpty else {
            showAlert(title: "Please enter notification title and content")
            return
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        
        let selectedRow = minutesPicker.selectedRow(inComponent: 0)
        let timeInterval = timeIntervals[selectedRow] * 60
        
        TimeInterval(timeInterval)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: repeatNotification)
        
        let request = UNNotificationRequest(identifier: "REQUEST", content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            } else {
                DispatchQueue.main.async {
                    self.showCheckMarkAnimation(mark: "bell.circle.fill")
                    print("Notification scheduled successfully")
                    // Dismiss the screen after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func showAlert(title: String) {
        let alertController = UIAlertController(title: "Alert", message: title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate methods
extension TimeIntervalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeIntervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return intervalLabels[row]
    }
}

// MARK: - UNUserNotificationCenterDelegate methods
extension TimeIntervalViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     
        print( " enter select")
        
//    TimeIntervalViewController: Handles the notification response when the app is in the foreground and presents the NotificationDetailViewController.

        let notificationContent = response.notification.request.content
        
        print("not data \(notificationContent.title)" )
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let notificationDetailVC = storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as? NotificationDetailViewController {
               notificationDetailVC.notificationTitle = notificationContent.title
               notificationDetailVC.notificationContent = notificationContent.body
               
            self.present(notificationDetailVC, animated: true, completion: nil)
        }else {
            print (" userNotificationCenteruserNotificationCenteruserNotificationCenter else ")
        }
           
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
