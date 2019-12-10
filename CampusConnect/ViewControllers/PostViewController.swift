//
//  PostViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-12-08.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import Firebase

/**
    Displays single post view

    - Author: Tim
*/
class PostViewController: UIViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var post : Post = Post()
    @IBOutlet var lblDueDate : UILabel!
    @IBOutlet var lblParticipants : UILabel!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var navigationBar : UINavigationBar!

    /**
        Create conversation between current logged in user and poster.
        - Parameter sender: Reference to the connected object in the storyboard.
    */
    @IBAction func sendMessage(sender: UIBarButtonItem) {
        let db = mainDelegate.firestoreDB!
        // Get list of conversation IDs and the recipient user ID
        db.collection("user_chat_list").document(mainDelegate.currentUserId!).collection("conversations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var conversationExists : Bool = false
                for document in querySnapshot!.documents {
                    if !conversationExists {
                        _ = document.get("conversation_id") as! String
                        let friendId = document.get("friend_id") as! String
                        if friendId == self.post.posterID! {
                            conversationExists = true
                        }
                    }
                }

                // Create new conversation document in Firebase if conversation between current user and poster
                // if conversation does not yet already exist.
                if !conversationExists {
                    var conversationRef: DocumentReference? = nil
                    conversationRef = db.collection("conversations").addDocument(data: [:]) { err in
                        if let _ = err {

                        } else {
                            db.collection("user_chat_list").document(self.mainDelegate.currentUserId!).collection("conversations").addDocument(data: [
                                "conversation_id": conversationRef!.documentID,
                                "friend_id": self.post.posterID!
                            ])
                            db.collection("user_chat_list").document(self.post.posterID!).collection("conversations").addDocument(data: [
                                "conversation_id": conversationRef!.documentID,
                                "friend_id": self.mainDelegate.currentUserId!
                            ])
                            self.dismiss(animated: true, completion: nil)
                            self.tabBarController?.selectedIndex = 3
                        }
                    }
                } else {
                    // do something with conversationId
                }
            }
        }
    }

    /**
        Initialize data during view lifecycle method viewDidLoad.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = post.title!
        navigationBar.prefersLargeTitles = false

        lblDueDate.text = post.dueDate!
        lblParticipants.text = "\(post.numOfStudents!) participant(s)"
        lblLocation.text = post.location!
        lblDescription.text = post.desc
    }
}
