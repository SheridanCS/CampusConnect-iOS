//
//  Message.swift
//  CampusCollab
//
//  Created by Laura Gonzalez on 2019-11-11.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var content : String?
    var sender : String?
    
    init(txt: String, sndr: String){
        content = txt
        sender = sndr
    }
}
