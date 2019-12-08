//
//  Chat_ViewController.swift
//  CampusCollab
//
//  Created by Laura Gonzalez on 2019-12-05.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UITableViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    private let db = Firestore.firestore()
    var currentUser : User!
    private var friendConvoID = "nil"
    var friend: User!
    var messages: [Message] = []
    
    //add text field should return!
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = friend.name
        navigationController?.navigationBar.prefersLargeTitles = false
        setupInputComponents()
        tableView.register(MessageCell.self, forCellReuseIdentifier: "id")
        tableView.separatorStyle = .none
        currentUser = mainDelegate.currentUser ?? User()
            db.collection("user_chat_list").document(self.currentUser.id!).collection("friends").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    //loops through user IDs in user_chat_list
                    for document in querySnapshot!.documents {
                        
                        //finds the friend user ID
                        if(document.documentID == (self.friend.id!)){
                            
                            print("found person")
                            //finds the convo we are talking to
                            if document.get("convoID") != nil {
                                self.friendConvoID = document.get("convoID") as! String
                                print("found friend")
                                self.getConversation()
                            }
                            
                        }
        
                    }
                }
            }
        
    }

    func getConversation(){
        
        if(self.friendConvoID != "nil"){
            db.collection("conversations").document(friendConvoID).collection("Messages").getDocuments()
                { (querySnapshot, err) in
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
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! MessageCell
    
        cell.messageLabel.text = messages[indexPath.row].content
        if messages[indexPath.row].sender == currentUser.name
        { cell.isIncoming = false } else { cell.isIncoming = true }
        return cell
    }
    
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
    
    @objc func handleSend(){

        if friendConvoID == "nil"{

            friendConvoID = (self.currentUser.id! + "" + friend.id!)
            db.collection("user_chat_list").document(self.currentUser.id!).collection("friends").document(friend.id!).setData(["convoID" : friendConvoID
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
        }
        saveMessage(message: inputTextField.text!)
        inputTextField.text = ""
    }

    

    func saveMessage(message:String){

        //func
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let time = formatter.string(from: currentDateTime)
       //conversations / convoID / time / Message / []
        db.collection("conversations").document(friendConvoID).collection("Messages").document(time).setData([ "sender":currentUser.name, "message":message
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        let msg = Message(txt: message, sndr: currentUser.name)
        self.messages.append(msg)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()

    }

    
    
}
