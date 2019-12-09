//
//  Post.swift
//  CampusCollab
//
//  Created by Brian Mulhall on 2019-12-06.

// Author: Brian Mulhall
// This is the Post Object, holds atributes of poster ID, title,
// due date, description, number of collaborators, and location of project.

import UIKit
import Foundation

class Post: NSObject {
    var posterID : String?
    var title : String?
    var dueDate : String?
    var desc : String?
    var numOfStudents : Int?
    var location : String?
    
    // This is the initializes the post with all of it's data for the iphone application
    func initWithData(title: String, dueDate: String, desc: String, numOfStudents: Int, location: String) {
        
        self.title = title
        self.dueDate = dueDate
        self.desc = desc
        self.numOfStudents = numOfStudents
        self.location = location
        
    }
    
    // This is an initializer that creates a post object with less data to send to the watch.
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
