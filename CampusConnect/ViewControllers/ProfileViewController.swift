//
//  ProfileViewController.swift
//  CampusConnect
//
//  Created by Stefan Tanaskovic on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.

import UIKit
import Firebase
import FirebaseFirestore

/**
    ViewController that handles displaying user information from firestore and allowing the user to logout
 
    - Author: Stefan Tanaskovic
*/
class ProfileViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var pickerSkill: UIPickerView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCampus: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblProgram: UILabel!
    var db: Firestore!
    var pickerData: [String] = []

    /**
        Returns back to ProfileView from EditProfileView and updates the users profile information
        - Parameter name: Storyboard
    */
    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        updateProfile()
    }
    
    /**
        Logs out user from appilcation
     
        - Parameter name:UIBarButtonItem
        - Author: Timothy Catibog
    */
    @IBAction func doLogout(sender: UIBarButtonItem) {
        print("Logging out...")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfile()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfile()
    }
    
   /**
       Updates users profile information and saves information to firestore
   */
    func updateProfile() {
        let uid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        let ref = db.collection("users").document(uid!)
        ref.getDocument { (snapshot, err) in
            if let data = snapshot?.data() {
                self.lblName.text = data["full_name"] as? String
                self.lblProgram.text = data["program"] as? String
                self.lblProgram.adjustsFontSizeToFitWidth = true
                self.lblEmail.text = data["email"] as? String
                self.lblCampus.text = data["campus"] as? String
                self.pickerSkill.delegate = self
                self.pickerSkill.dataSource = self
                self.pickerData = data["skills"] as? [String] ?? ["No skills"]
            } else {
                print("Couldn't find the document")
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
