//
//  TimeIntervalViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications

class TimeIntervalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet weak var notificationTitle: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var minutesPicker: UIPickerView!
    
    @IBOutlet weak var add: UIButton!
    
    var repeatNotification: Bool = false
    let timeIntervals = [1,10, 20, 30, 40, 50, 60]
    let intervalLabels = ["1 minutes","10 minutes", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes"]

    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimeIntervalViewController loaded")
        
        // Set up UIPickerView
        minutesPicker.dataSource = self
        minutesPicker.delegate = self
        
        userNotificationCenter.delegate = self
        add.layer.cornerRadius = 12
        
        notificationTitle.layer.borderColor =  UIColor.black.cgColor
        notificationTitle.layer.borderWidth = 1.0
        
        content.layer.borderColor = UIColor.black.cgColor
        content.layer.borderWidth = 1.0
        minutesPicker.selectRow(3, inComponent: 0, animated: false)

        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                   if granted {
                       print("Notification authorization granted")
                   } else {
                       print("Notification authorization denied")
                   }
               }
    }
    
    @IBAction func repeatSwitchChanged(_ sender: UISwitch) {
        repeatNotification = sender.isOn
    }
    
    @IBAction func addNotification(_ sender: Any) {
        // Validate input fields
        guard let title = notificationTitle.text, !title.isEmpty,
              let body = content.text, !body.isEmpty else {
            showAlert(title: "Please enter notification title and content")
            return
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        let selectedRow = minutesPicker.selectedRow(inComponent: 0)
        let timeInterval = timeIntervals[selectedRow] * 60 // Convert minutes to seconds
        
        print( "timeInterval \(timeInterval)")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: repeatNotification)
        
        let request = UNNotificationRequest(identifier: title, content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            } else {
                DispatchQueue.main.async {
                    self.showCheckMarkAnimation(mark: "bell.circle.fill")
                    print("Notification scheduled successfully")
//                    self.dismiss(animated: true)
                }}
        }
    }
    
    private func showAlert(title: String) {
        let alertController = UIAlertController(title: "Alart", message: title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate methods
    
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
