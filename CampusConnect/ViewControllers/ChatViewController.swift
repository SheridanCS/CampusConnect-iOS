//
//  ChatViewController.swift
//  CampusConnect
//
//  Created by Laura Gonzalez on 2019-12-05.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

/**
    ChatViewController is a tableview that organizes and displays messages sent between the user and their "friend", another user in the database

    - Author: Laura
*/

class ChatViewController: UITableViewController {
    //declare necessary variables and outlets
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    private var db: Firestore!
    var currentUser : ConnectUser?
    var recipientUser : ConnectUser?
    var conversationID : String? = nil
    var messages: [Message] = []
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    /**
        upon load, checks to see if a convrsation already exists and if it does, it grabs the messages, adding them onto message string array
            Then refreshes table to make sure messages grabbed are reflected on chat view (message bubbles appear)
     
        - Author: Laura
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        db = mainDelegate.firestoreDB
        navigationItem.title = recipientUser?.name
        navigationController?.navigationBar.prefersLargeTitles = false
        setupInputComponents()
        tableView.register(MessageCell.self, forCellReuseIdentifier: "id")
        tableView.separatorStyle = .none
        db.collection("conversations").document(self.conversationID!).collection("messages").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("found convo")
                    let msg = Message(txt: (document.get("message") as! String), sndr: (document.get("sender") as! String))
                    self.messages.append(msg)
                    print(document.get("message") as! String)
                }
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! MessageCell
    
        cell.messageLabel.text = messages[indexPath.row].content
        if messages[indexPath.row].sender == mainDelegate.currentUserObj.name
        { cell.isIncoming = false } else { cell.isIncoming = true }
        return cell
    }
    
    /**
        Adds UIViews for the bottom half of user chat, including send button and text field
         - Organizes using anchors and safeAreaLayoutGuide to make it look like a  user chat

        - Author: Laura
    */
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let height = CGFloat(50)
        NSLayoutConstraint.activate([
        containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -height),
        containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])

        containerView.addSubview(inputTextField)
        NSLayoutConstraint.activate([
            inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    /**
        calls save message and clears text input field

        - Author: Laura
    */
    @objc func handleSend() {
        saveMessage(message: inputTextField.text!)
        inputTextField.text = ""
    }

    /**
        gets user conversation database collection and saves the messages sender, content, and timestamp
            saves message according to conversation ID linked to user ID
                    
     
        - Parameter message: Sting content of message being sent.
        - Author: Laura
     */
    func saveMessage(message:String) {
        db.collection("conversations").document(conversationID!).collection("messages").addDocument(data: [
            "sender": self.mainDelegate.currentUserObj.name,
            "message": message,
            "timestamp": FieldValue.serverTimestamp()
        ])

        let msg = Message(txt: message, sndr: self.mainDelegate.currentUserObj.name)
        self.messages.append(msg)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
}
