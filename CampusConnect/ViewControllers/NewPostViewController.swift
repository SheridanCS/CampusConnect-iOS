//
//  NewPostViewController.swift
//  CampusConnect
//
//  Created by Brian Mulhall on 2019-11-19.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import MapKit



/**
    This is the view controller for the new post view. It includes the textfield delegate in order to dismiss the keyboard on screen taps,
    and MapKit to show the location a user enters.
 
    - Author: Brian Mulhall
*/

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

    
    /**
         This is the method that dismisses the software keyboard on done button pressed.
     
        - Parameter texField: UITextField from the stroyboard
        - Returns: ture
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true;
    }

    /**
         This is the method loads everything specified within when the storyboard view is loaded in the app.
         Includes placing the defualt location pin on the MapKit and looks for taps to dissmiss keyboard.
    */
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

    /**
         Calls this function when the tap is recognized.
    */
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /**
        This is the action method that is called when the location text feild is finished being edited.
         In tern it calls the locationTest method below.
    
        - Parameter sender: UITextField, when finished editing.
    */
    @IBAction func findLocation(_ sender: UITextField) {
        locationTest(enteredText: txtLocation.text!)
    }

    
    // Variable to store the CLLocation of a new post.
    var localForPost = CLLocation()

    /**
        This function creates a CLGeocoder and placemark in oder to find the location a user enters in the location text feild.
         It then focuses on that location using centerMapLocation(), and drops a pin on the CLLoation provided by the placemark data.
     
        - Parameter enteredText: The String grabed from the location TextFeild
    */
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

                // Center and Drop Pin
                self.centerMapOnLocation(location: self.coordToLoc(coord: coordinates))
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = placemark.name
                self.myMapView.addAnnotation(dropPin)
                self.myMapView.selectAnnotation(dropPin, animated: true)

            }
        })
    }

    /**
        This method converts a CLLocationCoordinate2D to a CLLocation for use elsewhere.
     
        - Parameter coord: CLLocationCoordinate2D sepcified
        - Returns: CLLocation object
    */
    func coordToLoc(coord: CLLocationCoordinate2D) -> CLLocation{
        let getLat: CLLocationDegrees = coord.latitude
        let getLon: CLLocationDegrees = coord.longitude
        let newLoc: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)

        self.localForPost = newLoc

        return newLoc
    }

    // Set the refion radios for how large the area to allow around a centered pin
    let regionRadius: CLLocationDistance = 15000
    
    /**
        This method centers on a given CLLocation object using the MKCoordinateRegion() mothod provided by MapKit
     
        - Parameter location: CLLocation sepcified
    */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    /**
        This method saves the new post that the user has just created. It formats the date grabbed from the date picker, then accesses
         the Firestore db in order to save the post to the database. This is done with the addDocument() Firebase method.
         Resets the form and sends the user back to the Feed.
     
        - Parameter sender: UIButton from storyboard
        - Returns: Print to console wither or not document was written successfully
    */
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
    
    /**
        This method saves the new post that the user has just created. It formats the date grabbed from the date picker, then accesses
         the Firestore db in order to save the post to the database. This is done with the addDocument() Firebase method.
     
        - Parameter sender: UIButton from storyboard
        - Returns: Print to console wither or not document was written successfully
    */
    @IBAction func stepperValueChanged(sender: UIStepper) {
        lblNumOfStudents.text = Int(sender.value).description
    }

    /**
        This is an IBAction that's called whe nthe Discard button is pressed.
     
        - Parameter sender: UIButton from storyboard
    */
    @IBAction func discardPost(sender : UIButton){
        resetForm()
    }
    
    /**
        This method resets the new post view and all of it's feilds. Including the Stepper and the MapView to it's orignal position/values.
    */
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
