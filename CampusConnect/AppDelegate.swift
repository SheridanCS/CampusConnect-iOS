//
//  AppDelegate.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firestoreDB : Firestore?
    var currentUserId : String?
    var currentUserObj : ConnectUser = ConnectUser()
//    var people : [User] = []
//    var currentUser : User!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        firestoreDB = Firestore.firestore()

        //MARK:WRITING
//        let currentDateTime = Date()
//        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
//        formatter.dateStyle = .long
//        let time = formatter.string(from: currentDateTime)
//
//        firestoreDB!.collection("conversations").document("conversation_id_1").setData([
//            time : ["sender":"laura", "message":"hello"]
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//        firestoreDB!.collection("user_chat_list").document("user_id_1").setData([
//            "ID": ["conversation_id_1","conversation_id_2"]
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }

        //MARK: READING
//        firestoreDB!.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//
//                    let newUser = User()
//                    newUser.id = document.documentID
//                    newUser.name = document.get("full_name") as! String
//                    newUser.email = document.get("email") as! String
//
//                    if newUser.name == "Laura"{
//                        self.currentUser = newUser
//                    }
//                    else {
//                        //ADD ONTO PEOPLE LIST
//                        print("adding to people array, user id and name:", newUser.id!, "---", newUser.name)
//                        self.people.append(newUser)
//                    }
//
//                }
//            }
//        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func updateCurrentUser() {
        self.firestoreDB?.collection("users").document(self.currentUserId!).getDocument { (document, err) in
            self.currentUserObj = ConnectUser()
            self.currentUserObj.name = "\(String(describing: document!.data()!["full_name"]))"
            self.currentUserObj.email = "\(String(describing: document!.data()!["email"]))"
        }
    }
}

