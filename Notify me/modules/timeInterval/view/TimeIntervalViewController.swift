//
//  TimeIntervalViewController.swift
//  Notify me
//
//  Created by mayar on 05/07/2024.
//

import UIKit
import UserNotifications
import CoreLocation
import MapKit

class TimeViewController: UIViewController, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
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
    var mapView = MKMapView()
    let geocoder = CLGeocoder()
    var notificationID : String = ""
    
    var locationManager = CLLocationManager()
    var chosenLocation: CLLocationCoordinate2D?
    
    let timeIntervals = [1, 10, 20, 30, 40, 50, 60]
    let intervalLabels = ["1 minute", "10 minutes", "20 minutes", "30 minutes", "40 minutes", "50 minutes", "60 minutes"]
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNotificationCenter.delegate = self
        minutesPicker.dataSource = self
        minutesPicker.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
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
        
        if comeAsMap {
            pageTitle.title = "Add notification at a location"
            mapView.showsUserLocation = true
            labelBesidPicker.text = "Around:"
            
            view.addSubview(raduis)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
              mapView.addGestureRecognizer(tapGesture)
            view.addSubview(mapView)
            addMapConstraints(mapView: mapView)
        } else {
            raduis.isHidden = true
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
                datePicker.minimumDate = Date() // This ensures only future dates and times can be selected

                view.addSubview(datePicker)
                addDatePickerConstraints(picker: datePicker)
            }
        }
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: mapView)
        let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        chosenLocation = tappedCoordinate
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = tappedCoordinate
        mapView.addAnnotation(annotation)
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
    
    private func addMapConstraints(mapView: UIView) {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentOfNOtifiction.topAnchor.constraint(equalTo: notificationTitle.bottomAnchor, constant: 40),
            mapView.topAnchor.constraint(equalTo: labelBesidPicker.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapView.bottomAnchor.constraint(equalTo: add.topAnchor, constant: -20),
            add.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-20)
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

            if comeAsMap {
                guard let chosenLocation = chosenLocation else {
                    Alert.showAlert(title: "Please select a location on the map", uiView: self)
                    return
                }

                guard let radiusText = raduis.text, let radiusValue = Double(radiusText) else {
                    Alert.showAlert(title: "Please enter a valid radius for the region", uiView: self)
                    return
                }

                add.isEnabled = false

                let region = CLCircularRegion(center: chosenLocation, radius: radiusValue, identifier: UUID().uuidString)
                region.notifyOnEntry = true
                region.notifyOnExit = false
                trigger = UNLocationNotificationTrigger(region: region, repeats: true)

                // Reverse Geocoding to get location name
                let location = CLLocation(latitude: chosenLocation.latitude, longitude: chosenLocation.longitude)
                geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                    guard let self = self else { return }
                    if let error = error {
                        print("Reverse geocode failed: \(error.localizedDescription)")
                        return
                    }

                    if let placemark = placemarks?.first {
                        self.notificationLocationName = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
                    }

                    self.scheduleNotification(content: notificationContent, trigger: trigger)
                }
            } else {
                if comeAsTimeInterval {
                    let selectedRow = minutesPicker.selectedRow(inComponent: 0)
                    afterTime = timeIntervals[selectedRow]
                    let timeInterval = timeIntervals[selectedRow] * 60
                    
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)

                    
                } else {
                    let selectedDate = datePicker.date
                    let triggerDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: selectedDate)
                    dateAndTime = "\(triggerDate)"
                    trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                }
                scheduleNotification(content: notificationContent, trigger: trigger)
            }
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
   
extension TimeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            chosenLocation = annotation.coordinate
        }
    }
}
