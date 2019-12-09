//
//  AppDelegate.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import Firebase

/**
    AppDelegate that handles the instantiation of the Firebase application and Cloud Firestore DB

    - Author: Timothy Catibog
*/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firestoreDB : Firestore?
    var currentUserId : String?
    var currentUserObj : ConnectUser = ConnectUser()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        firestoreDB = Firestore.firestore()

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

    /**
        Once login is completed, populate the current user's ID and data.
    */
    func updateCurrentUser() {
        self.firestoreDB?.collection("users").document(self.currentUserId!).getDocument { (document, err) in
            self.currentUserObj = ConnectUser()
            self.currentUserObj.name = document!.get("full_name") as! String
            self.currentUserObj.email = document!.get("email") as! String
            let campus = document!.get("campus") as! String
            let program = document!.get("program") as! String
            if !campus.isEmpty {
                self.currentUserObj.campus = Campus(rawValue: campus)!
            }
            if !program.isEmpty {
                self.currentUserObj.program = program
            }
        }
    }
}

