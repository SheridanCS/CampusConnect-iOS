//
//  LoginViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    var mainDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!

    // MARK: Control Methods
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {}
    @IBAction func doLogin() {
        self.doFirebaseLogin(username: tfEmail.text!, password: tfPassword.text!)
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

    func doFirebaseLogin(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
            if error != nil {
                self!.presentAlert(title: "Login Error", message: error!.localizedDescription, preferredStyle: .alert)
            } else {
                self!.mainDelegate.currentUserId = authResult?.user.uid
                self!.mainDelegate.updateCurrentUser()
                self!.performSegue(withIdentifier: "MainAppTabBar", sender: self)
            }
        }
    }

    func presentAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}
