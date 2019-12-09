//
//  ChatListViewController.swift
//  CampusConnect
//
//  Created by Laura Gonzalez on 2019-12-05.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import UIKit
import FirebaseAuth

/**
    ChatListViewController handles a UITableView that displays the "friends" of the user, the people he or she wishes to chat with
        Associations between user and friends are saved in the database
            Upon clicking on a username, it brings them to a chatview where they can then send messages
 
    - Author: Laura & Tim
*/

class ChatListViewController: UITableViewController {
    //declare necessary variables and outlets
    @IBOutlet var myTable : UITableView!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer : Timer!
    var conversationList : [String] = []
    var friendsList : [String] = []
    var friends : [ConnectUser] = []

    /**
        refreshes table to show past conversations on table, reflect changes from get conversation ID

        - Author: Laura
    */
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true);
       }

       @objc func refreshTable(){
        if (conversationList.count > 0) {
            self.myTable.reloadData()
            self.timer.invalidate()
        }
    }

    /**
         in load, changes nav title and calls get conversations id to get past users conversations

        - Author: Laura
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
        self.getConversationIDs()
    }

    //necessary table view UI methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    //table view cell where name appears
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : SiteCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell (style: .default, reuseIdentifier: "cell")
        tableCell.primaryLabel.text = self.friends[indexPath.row].name
        return tableCell
    }

    /**
        upon clicking a cell with name, navigates to chat view

        - Author: Laura
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            let vc = ChatViewController()
            vc.conversationID = self.conversationList[indexPath.row]
            vc.recipientUser = self.friends[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
    }

    /**
        Grabs past conversations in user_chat_list collection in firestore database
            -Adds conversations onto conversationList
            -Adds friend's (they were conversating with) user information onto friendsList with association to user collection
     
         Refreshes table to update friends names in table view selection
     
        - Author:  Tim
    */
    func getConversationIDs() {
        let uid = mainDelegate.currentUserId
        print("Getting conversation IDs")
        print(uid!)
        mainDelegate.firestoreDB?.collection("user_chat_list").document(uid!).collection("conversations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let conversationId = document.get("conversation_id") as! String
                    let friendId = document.get("friend_id") as! String
                    print(conversationId, friendId)
                    self.conversationList.append(conversationId)
                    self.friendsList.append(friendId)
                    self.mainDelegate.firestoreDB?.collection("users").document(friendId).getDocument { (document, err) in
                        let cUser = ConnectUser()
                        cUser.name = document?.get("full_name") as! String
                        self.friends.append(cUser)
                    }
                }
            }
        }
        self.refreshTable()
    }
    
}
