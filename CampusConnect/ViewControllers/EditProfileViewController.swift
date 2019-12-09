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
    var programList = AvailablePrograms()
    var skills = ProfileViewController()
    @IBOutlet weak var txtSkills: UITextField!
    @IBOutlet weak var pickerProgram: UIPickerView!
    @IBOutlet weak var pickerCampus: UIPickerView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    var picker1Options = [] as [String]
    var picker2Options = [] as [String]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerProgram.delegate = self
        self.pickerProgram.dataSource = self
        self.pickerCampus.delegate = self 
        self.pickerCampus.dataSource = self
        
        picker1Options = ["Davis","Hazel McCallion","Trafalgar"]
        picker2Options = programList.programs
        getSkills()


        // Do any additional setup after loading the view.
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
        if (txtName.text != "" && txtEmail.text != ""){
            let ref = mainDelegate.firestoreDB!.collection("users").document(mainDelegate.currentUserId!)
            let docData: [String: Any] = [
                "full_name": txtName.text!,
                "program": picker2Options[pickerProgram.selectedRow(inComponent: 0)],
                "email": txtEmail.text!,
                "skills" : txtSkills.text!.components(separatedBy: ","),
                "campus" : picker1Options[pickerCampus.selectedRow(inComponent: 0)]
            ]
            ref.setData(docData) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
            if txtEmail.text != Auth.auth().currentUser?.email! {
                updateEmail()
            }
            let alert = UIAlertController(title: "Succesful", message: "Profile Information Updated", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        if pickerView.tag == 1 {
            return picker1Options.count
        } else {
            return picker2Options.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Ariel", size: 8)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.adjustsFontSizeToFitWidth = true

        if pickerView.tag == 1 {
            pickerLabel?.text = picker1Options[row]
            return pickerLabel!
        } else {
            pickerLabel?.text = picker2Options[row]
            return pickerLabel!
        }
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
