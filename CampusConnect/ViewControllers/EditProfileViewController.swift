//
//  EditProfileViewController.swift
//  CampusConnect
//
//  Created by Stefan Tanaskovic on 2019-11-29.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let pckCampusOptions : [String] = ["Davis","Hazel McCallion","Trafalgar"]
    let pckProgramOptions : [String] = AvailablePrograms().programs

    let pckCampus : UIPickerView! = UIPickerView()
    let pckProgram : UIPickerView! = UIPickerView()
    var skills = ProfileViewController()
    @IBOutlet weak var txtSkills: UITextField!
    @IBOutlet weak var txtCampus : UITextField!
    @IBOutlet weak var txtProgram : UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtName.text = mainDelegate.currentUserObj.name
        self.txtEmail.text = mainDelegate.currentUserObj.email
        self.txtCampus.text = mainDelegate.currentUserObj.campus.rawValue
        self.txtProgram.text = mainDelegate.currentUserObj.program

        pckCampus.delegate = self
        pckCampus.dataSource = self
        pckCampus.tag = 0
        txtCampus.inputView = pckCampus

        pckProgram.delegate = self
        pckProgram.dataSource = self
        pckProgram.tag = 1
        txtProgram.inputView = pckProgram

        getSkills()
    }
    
    func getSkills(){
        let db = mainDelegate.firestoreDB
        let ref = db!.collection("users").document(mainDelegate.currentUserId!)
        ref.getDocument { (snapshot, err) in
            if let data = snapshot?.data() {
                let temp = data["skills"] as! [String]
                self.txtSkills.text = temp.joined(separator: ", ")
            } else {
                print("Couldn't find the document")
            }
       }
   }

    
    @IBAction func updateDB(_ sender: Any) {
        if (txtName.text != "" && txtEmail.text != "") {
            let ref = mainDelegate.firestoreDB!.collection("users").document(mainDelegate.currentUserId!)
            let docData: [String: Any] = [
                "full_name": txtName.text!,
                "program": pckProgramOptions[pckProgram.selectedRow(inComponent: 0)],
                "email": txtEmail.text!,
                "skills" : txtSkills.text!.components(separatedBy: ","),
                "campus" : pckCampusOptions[pckCampus.selectedRow(inComponent: 0)]
            ]
            ref.setData(docData) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
            if txtEmail.text != Auth.auth().currentUser?.email! {
                updateEmail()
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please make sure email and name are filled out", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? pckCampusOptions.count : pckProgramOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? pckCampusOptions[row] : pckProgramOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            txtCampus.text = pckCampusOptions[row]
        } else {
            txtProgram.text = pckProgramOptions[row]
        }
        self.view.endEditing(true)
    }
    
    func updateEmail() {
        let db = mainDelegate.firestoreDB!
        Auth.auth().currentUser?.updateEmail(to: txtEmail.text!) { error in
            if let error = error {
                print(error)
            } else {
                let uid = Auth.auth().currentUser!.uid
                let userRef = db.collection("users").document(uid)
                userRef.updateData([
                    "email": self.txtEmail.text!
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
           }
       }
    }
}
