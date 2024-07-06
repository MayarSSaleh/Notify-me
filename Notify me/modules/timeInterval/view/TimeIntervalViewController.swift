//
//  TimeIntervalViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications

class TimeViewController: UIViewController , UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notificationTitle: UITextView!
    @IBOutlet weak var contentOfNOtifiction: UITextView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var labelBesidPicker: UILabel!
    @IBOutlet weak var pageTitle: UINavigationItem!
    
    @IBOutlet weak var Repeats: UILabel!
    
    var comeAsTimeInterval: Bool = true
    var minutesPicker =  UIPickerView()
    var datePicker = UIDatePicker()

    var repeatNotification: Bool = true
    let timeIntervals = [1,10, 20, 30, 40, 50, 60]
    let intervalLabels = ["1 minutes","10 minutes", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes"]
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNotificationCenter.delegate = self
        minutesPicker.dataSource = self
        minutesPicker.delegate = self

        setUp()
    }
    
   private func setUp(){
       contentOfNOtifiction.layer.borderColor = UIColor.black.cgColor
       contentOfNOtifiction.layer.borderWidth = 1
       notificationTitle.layer.borderColor = UIColor.black.cgColor
       notificationTitle.layer.borderWidth = 1
       add.layer.cornerRadius = 12

       if comeAsTimeInterval {
           labelBesidPicker.text = "After:"
           pageTitle.title = "Add notification after a time"
           minutesPicker.selectRow(3, inComponent: 0, animated: false)
           view.addSubview(minutesPicker)
           addPickerConstraints(picker: minutesPicker)
       } else {
           labelBesidPicker.text = "At:"
           pageTitle.title = "Add notification at a specific time"
           datePicker.datePickerMode = .dateAndTime
           view.addSubview(datePicker)
           addDatePickerModeConstraints(picker: datePicker)
       }
    }
    
    private func addPickerConstraints(picker: UIView) {
           picker.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               picker.topAnchor.constraint(equalTo: labelBesidPicker.topAnchor, constant: -100),
               picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               picker.heightAnchor.constraint(equalToConstant: 215)
           ])
       }
    
    private func addDatePickerModeConstraints(picker: UIView) {
           picker.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            labelBesidPicker.topAnchor.constraint(equalTo: Repeats.bottomAnchor, constant: 70),
               picker.topAnchor.constraint(equalTo: labelBesidPicker.topAnchor, constant: 0),
               picker.leadingAnchor.constraint(equalTo:notificationTitle.leadingAnchor, constant: 0)
           ])
       }
    @IBAction func repeatSwitchChanged(_ sender: UISwitch) {
        repeatNotification = sender.isOn
    }
    
    @IBAction func addNotification(_ sender: Any) {
        guard let title = notificationTitle.text, !title.isEmpty,
              let body = contentOfNOtifiction.text, !body.isEmpty else {
            Alart.showAlert(title: "Please enter notification title and content", uiView: self)
            return
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        
        var trigger: UNNotificationTrigger
        
        if comeAsTimeInterval {
            let selectedRow = minutesPicker.selectedRow(inComponent: 0)
            var timeInterval = timeIntervals[selectedRow] * 60
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: repeatNotification)

          //  trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: repeatNotification)
        } else {
            let selectedDate = datePicker.date
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeatNotification)
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            } else {
                DispatchQueue.main.async {
                    self.showCheckMarkAnimation(mark: "bell.circle.fill")
                    print("Notification scheduled successfully")
                    // Dismiss the screen after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // for application in for ground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
        
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate methods
extension TimeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
   
