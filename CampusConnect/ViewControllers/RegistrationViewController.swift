//
//  RegistrationViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//


import UIKit
import FirebaseAuth

/**
    View controller class to handle registration.
    - Author: Timothy Catibog
*/
class RegistrationViewController: UIViewController, UITextFieldDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword1 : UITextField!
    @IBOutlet var tfPassword2 : UITextField!

    /**
        Storyboard connected button to initiate the registration process.
        - Parameter sender: UI object used to perform the action.
    */
    @IBAction func register(sender : UIButton) {
        if isValidUserInfo() {
            self.doFirebaseRegistration(username: tfEmail.text!, password: tfPassword1.text!)
        }
    }

    // MARK: ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {}

    /**
        Validate the information given to register. Presents an alert if data is found to be invalid.
        - Returns: Bool.
    */
    func isValidUserInfo() -> Bool {
        if tfName.text!.isEmpty {
            presentAlert(title: "Missing Information", message: "Full name is required", preferredStyle: .alert)
            return false
        }
        if tfEmail.text!.isEmpty {
            presentAlert(title: "Missing Information", message: "Email address is required", preferredStyle: .alert)
            return false
        }
        if tfPassword1.text!.isEmpty || tfPassword2.text!.isEmpty {
            presentAlert(title: "Missing Information", message: "Password fields are required", preferredStyle: .alert)
            return false
        }
        if tfPassword1.text! != tfPassword2.text! {
            presentAlert(title: "Bad Information", message: "Password fields do not match", preferredStyle: .alert)
            return false
        }

        return true
    }

    /**
        Attempt to register the user with the given username and password credentials.
        - Parameter username: Username of the user.
        - Parameter password: Password of the user.
    */
    func doFirebaseRegistration(username: String, password: String) {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if error != nil {
                self.presentAlert(title: "Registration Error", message: error!.localizedDescription, preferredStyle: .alert)
            } else {
                self.mainDelegate.firestoreDB?.collection("users").document((authResult?.user.uid)!).setData([
                    "full_name": self.tfName.text!,
                    "email": self.tfEmail.text!,
                    "campus": Campus.trafalgar.rawValue,
                    "program": AvailablePrograms().programs[0],
                    "skills": []
                ])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    /**
        Convenience method to create and present an alert for a given title, message, and style.
        - Parameter title: Title of the alert.
        - Parameter message: Message to go into body of the alert.
        - Parameter preferredStyle: Style to apply to the alert.
    */
    func presentAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert: UIAlertAction!) in
        })

        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}
