//
//  User.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import Foundation

/**
    Model of the user of the application.

    - Author: Timothy Catibog
*/
class ConnectUser : NSObject {
    var id : String?
    var name : String
    var email : String
    var campus : Campus
    var program : String
    var skills : [String]?

    /**
        Initialize an empty/default object of this class.
    */
    override init() {
        self.name = ""
        self.email = ""
        self.campus = .trafalgar
        self.program = ""
    }

    /**
        Initialize an object of this class with data.

        - Parameter name: The full name of the user.
        - Parameter email: The email address of the user.
        - Parameter campus: The campus of the user.
        - Parameter program: The program the user is taking at Sheridan.
    */
    init(name: String, email: String, campus: Campus, program: String) {
        self.name = name
        self.email = email
        self.campus = campus
        self.program = program
    }
}
