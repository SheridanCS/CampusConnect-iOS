//
//  NewPostViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import MapKit

class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate {

    @IBOutlet var myMapView : MKMapView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblNumOfStudents: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var stepper: UIStepper!

    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 43.469053, longitude: -79.699467)

    var db: Firestore!

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true;
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        myMapView.delegate = self;
        myMapView.isUserInteractionEnabled = false;

        txtTitle.delegate = self;
        txtLocation.delegate = self;

        // Drop Pin on Initial Location
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation( dropPin, animated: true)

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func findLocation(_ sender: UITextField) {
        Swift.print("This is working...")
        locationTest(enteredText: txtLocation.text!)
    }

    var localForPost = CLLocation()

    func locationTest(enteredText: String) {

        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(enteredText, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }

            if let placemark = placemarks?.first {

                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate

                self.myMapView.removeAnnotations(self.myMapView.annotations)
                self.myMapView.removeOverlays(self.myMapView.overlays)

                // Drop Pin
                self.centerMapOnLocation(location: self.coordToLoc(coord: coordinates))
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = placemark.name
                self.myMapView.addAnnotation(dropPin)
                self.myMapView.selectAnnotation(dropPin, animated: true)

            }
        })
    }

    func coordToLoc(coord: CLLocationCoordinate2D) -> CLLocation{
        let getLat: CLLocationDegrees = coord.latitude
        let getLon: CLLocationDegrees = coord.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)

        self.localForPost = newLoc

        return newLoc
    }

    // Center Map on Pinned Location
    let regionRadius: CLLocationDistance = 15000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        myMapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func savePost(sender : UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let postDate = dateFormatter.string(from: self.datePick.date)
        
        db = mainDelegate.firestoreDB!

        db.collection("posts").addDocument(data: [
            "poster_id": mainDelegate.currentUserId!,
            "project_title": self.txtTitle.text!,
            "project_desc": self.txtDescription.text!,
            "num_of_students": Int(self.lblNumOfStudents.text!) ?? 1,
            "due_date" : postDate,
            "location" : GeoPoint(latitude: localForPost.coordinate.latitude, longitude: localForPost.coordinate.longitude)
            ])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        resetForm()
        tabBarController?.selectedIndex = 0
        
    }

    @IBAction func stepperValueChanged(sender: UIStepper) {
        lblNumOfStudents.text = Int(sender.value).description
    }

    @IBAction func discardPost(sender : UIButton){
        
        resetForm()
        
    }
    
    func resetForm() {
        
        // Reset Textfields
        self.txtTitle.text = nil
        self.txtDescription.text = nil
        self.txtLocation.text = nil
        self.lblNumOfStudents.text = "1"
        
        // Reset Date Picker and Stepper
        datePick.setDate(Date(), animated: true)
        stepper.value = 1
        
        // Reset MapView
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        self.myMapView.removeOverlays(self.myMapView.overlays)
        
        // Drop pin and center on initial location
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation( dropPin, animated: true)
        
    }

}
