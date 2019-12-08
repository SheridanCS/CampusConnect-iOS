//
//  Post.swift
//  CampusCollab
//
//  Created by Brian Mulhall on 2019-12-06.
//  Copyright © 2019 Laura Gonzalez. All rights reserved.
//

import UIKit
import Foundation

class Post: NSObject {
    
    var title : String
    var dueDate : String
    var desc : String
    var numOfStudents : Int
    var location : String
    
    override init() {
        
        self.title = ""
        self.dueDate = ""
        self.desc = ""
        self.numOfStudents = 0
        self.location = ""
        
    }
    
    init(title:String, dueDate:String, desc:String, numOfStudents:Int, location:String) {
        
        self.title = title
        self.dueDate = dueDate
        self.desc = desc
        self.numOfStudents = numOfStudents
        self.location = location
        
    }
    
}
