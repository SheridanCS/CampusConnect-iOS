//
//  Message.swift
//  CampusCollab
//
//  Created by Laura Gonzalez on 2019-11-11.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import Foundation
import UIKit


/**
    Message model for Chat functionality.
 
    - Author: Laura Gonzalez
*/
class Message {
    var content : String?
    var sender : String?

    /**
        Initialize the object.
        - Parameter txt: String value for the message content.
        - Parameter sndr: String value for the sender.
        - Author: Your name
    */
    init(txt: String, sndr: String){
        content = txt
        sender = sndr
    }
}
