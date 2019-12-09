//
//  RegistrationViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword1 : UITextField!
    @IBOutlet var tfPassword2 : UITextField!

    @IBAction func register(sender : UIButton) {
        if isValidUserInfo() {
            self.doFirebaseRegistration(username: tfEmail.text!, password: tfPassword1.text!)
        }
    }

    // MARK: ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

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

    func presentAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert: UIAlertAction!) in
//            self.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}
