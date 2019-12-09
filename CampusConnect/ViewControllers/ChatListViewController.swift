//
//  MessagesTableViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatListViewController: UITableViewController {
    @IBOutlet var myTable : UITableView!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer : Timer!
    var conversationList : [String] = []
    var friendsList : [String] = []
    var friends : [ConnectUser] = []

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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
        self.getConversationIDs()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : SiteCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell (style: .default, reuseIdentifier: "cell")
        tableCell.primaryLabel.text = self.friends[indexPath.row].name
        return tableCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.conversationID = self.conversationList[indexPath.row]
        vc.recipientUser = self.friends[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)
    }

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
                        self.refreshTable()
                    }
                }
            }
        }
    }
}
