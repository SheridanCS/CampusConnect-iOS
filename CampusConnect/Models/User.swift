//
//  User.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import Foundation

class User : NSObject {
    var name : String
    var email : String
    var campus : Campus
    var program : String
    var skills : [String]?

    override init() {
        self.name = ""
        self.email = ""
        self.campus = .trafalgar
        self.program = ""
    }

    init(name: String, email: String, campus: Campus, program: String) {
        self.name = name
        self.email = email
        self.campus = campus
        self.program = program
    }
}
