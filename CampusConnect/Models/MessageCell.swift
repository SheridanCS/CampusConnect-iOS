//
//  MessageCell.swift
//  CampusCollab
//
//  Created by Laura Gonzalez on 2019-12-06.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import UIKit

/**
    Provides the container for the table cell data within a chat conversation.
    - Author: Laura Gonzalez
*/

class MessageCell: UITableViewCell {
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var isIncoming: Bool!{
        didSet {
            bubbleBackgroundView.backgroundColor = isIncoming ? .lightGray : .blue
            messageLabel.textColor = isIncoming ? .black : .white
            
            if isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    /**
        Description of class or function
        - Parameter style: UITableViewCell.CellStyle style for the table cell.
        - Parameter reuseIdentifier: String of the identifier.
    */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        bubbleBackgroundView.backgroundColor = .lightGray
        bubbleBackgroundView.layer.cornerRadius = 13
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
