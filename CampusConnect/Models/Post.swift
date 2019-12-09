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
    
    var title : String?
    var dueDate : String?
    var desc : String?
    var numOfStudents : Int?
    var location : String?
    
    func initWithData(title:String, dueDate:String, desc:String, numOfStudents:Int, location:String) {
        
        self.title = title
        self.dueDate = dueDate
        self.desc = desc
        self.numOfStudents = numOfStudents
        self.location = location
        
    }
    
    func initWithLessData(title:String, dueDate:String) {
        
        self.title = title
        self.dueDate = dueDate
        
    }
    
    // Encode the object into bits to send to the watch
     func encode(with aCoder: NSCoder) {
         aCoder.encode(self.title, forKey : "title")
         aCoder.encode(self.dueDate, forKey : "dueDate")
     }
     
     
     required convenience init?(coder aDecoder: NSCoder) {
         
         guard let title = aDecoder.decodeObject(forKey: "title") as? String,
             let dueDate = aDecoder.decodeObject(forKey: "dueDate") as? String
             else { return nil }
         
        self.init()
        self.initWithLessData(title: title, dueDate: dueDate)
     }
    
}
