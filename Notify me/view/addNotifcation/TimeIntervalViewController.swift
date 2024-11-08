//
//  TimeIntervalViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications

class setNotificationDetails: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notificationTitle: UITextView!
    @IBOutlet weak var contentOfNOtifiction: UITextView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var labelBesidPicker: UILabel!
    @IBOutlet weak var pageTitle: UINavigationItem!
    @IBOutlet weak var raduis: UITextView!
    
    var comeAsTimeInterval: Bool = true
    var comeAsMap: Bool = false
    var afterTime :Int?
    var notificationLocationName:String?
    var viewModel = CreateNotificationViewModel()
    var dateAndTime : String?
    var minutesPicker = UIPickerView()
    var datePicker = UIDatePicker()
    var notificationID : String = ""
    let timeIntervals = [1, 10, 20, 30, 40, 50, 60]
    let intervalLabels = ["1 minute", "10 minutes", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes"]
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNotificationCenter.delegate = self
        minutesPicker.dataSource = self
        minutesPicker.delegate = self
        setUp()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationID = UUID().uuidString
    }
    
    private func setUp() {
        contentOfNOtifiction.layer.borderColor = UIColor.black.cgColor
        contentOfNOtifiction.layer.borderWidth = 1
        notificationTitle.layer.borderColor = UIColor.black.cgColor
        notificationTitle.layer.borderWidth = 1
        raduis.layer.borderColor = UIColor.black.cgColor
        raduis.layer.borderWidth = 1
        add.layer.cornerRadius = 12
        raduis.isHidden = true
        
        if comeAsTimeInterval {
                labelBesidPicker.text = "After:"
                pageTitle.title = "Add notification after a while "
                minutesPicker.selectRow(3, inComponent: 0, animated: false)
                view.addSubview(minutesPicker)
                addPickerConstraints(picker: minutesPicker)
            } else {
                labelBesidPicker.text = "Date:"
                pageTitle.title = "Add notification at Date"
                datePicker.datePickerMode = .dateAndTime
                datePicker.minimumDate = Date() // This ensures only future dates and times can be selected
                view.addSubview(datePicker)
                addDatePickerConstraints(picker: datePicker)
            }
    }
    
    private func addPickerConstraints(picker: UIView) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelBesidPicker.topAnchor.constraint(equalTo: contentOfNOtifiction.bottomAnchor, constant: 80),
            picker.topAnchor.constraint(equalTo: labelBesidPicker.topAnchor, constant: -100),
            
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            picker.heightAnchor.constraint(equalToConstant: 215)
        ])
    }
    
    private func addDatePickerConstraints(picker: UIView) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelBesidPicker.topAnchor.constraint(equalTo: contentOfNOtifiction.bottomAnchor, constant: 60),
            picker.topAnchor.constraint(equalTo: labelBesidPicker.topAnchor, constant: 0),
            picker.leadingAnchor.constraint(equalTo: notificationTitle.leadingAnchor, constant: 0)
        ])
    }
    
    
    @IBAction func addNotification(_ sender: Any) {
        guard let title = notificationTitle.text, !title.isEmpty,
                  let body = contentOfNOtifiction.text, !body.isEmpty else {
                Alert.showAlert(title: "Please enter notification title and content", uiView: self)
                return
            }

            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.body = body
            notificationContent.sound = .default
            notificationContent.userInfo = ["title": notificationContent.title, "body": notificationContent.body , "self.notificationID" : self.notificationID]

            var trigger: UNNotificationTrigger?

                if comeAsTimeInterval {
                    let selectedRow = minutesPicker.selectedRow(inComponent: 0)
                    afterTime = timeIntervals[selectedRow]
                    let timeInterval = timeIntervals[selectedRow] * 60
                    
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
                    
                    
                    // for testing appear after 7 second
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                } else {
                    let selectedDate = datePicker.date
                    let triggerDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: selectedDate)
                    dateAndTime = "\(triggerDate)"
                    print("dateAndTime at creating \(dateAndTime) ")
                    trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                }
                scheduleNotification(content: notificationContent, trigger: trigger)
            }
        

        private func scheduleNotification(content: UNMutableNotificationContent, trigger: UNNotificationTrigger?) {
            guard let trigger = trigger else { return }
            
            
            let request = UNNotificationRequest(identifier:notificationID , content: content, trigger: trigger)
            
            userNotificationCenter.add(request) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Notification Error: ", error)
                } else {
                    DispatchQueue.main.async {
                        self.viewModel.saveNotification(
                            title: content.title,
                            notificationIdentifier: self.notificationID,
                            content: content.body,
                            repeatNotification: false,
                            isNotificationByTime: self.comeAsTimeInterval,
                            isNocationByLocation: self.comeAsMap,
                            showingMessangeAfterTime: " Notification afte \(DateFormating.getCurrentDateTime()) by: \(self.afterTime ?? 0) minutes",
                            createdDate: Date(),
                            locationName: self.notificationLocationName,
                            afterTime: self.afterTime ?? 0,
                            atTimeAndDate: self.dateAndTime
                        )

                        self.showCheckMarkAnimation(mark: "bell.circle.fill")
                        print("Notification scheduled successfully")
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
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate methods
extension setNotificationDetails: UIPickerViewDataSource, UIPickerViewDelegate {
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
