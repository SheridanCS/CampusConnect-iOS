//
//  FeedInterfaceController.swift
//  CampusConnectWatchApp Extension
//
//  Created by Brian Mulhall on 2019-12-08.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

/**
    This is the InterfaceController for the watch app screen that displays the pists from the phone app, using a table.
 
    - Author: Brian Mulhall
*/
class FeedInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var feedTable: WKInterfaceTable!
    
    var posts : [Post] = []
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    /**
        On awake fthe watch will initialize a connection with the phone.
    */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        Swift.print("Awake now...")
        
        // Initiate connection from watch to phone
        if(WCSession.isSupported())
        {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    /**
        Function override from WatchKit, is called just before the watch view controller is about to be visible to user
         It unachrvies the message sent from the phone after sending a request. Had some issues with UnArchiver, which is described bellow. - Brian
    */

    override func willActivate() {
        
        super.willActivate()
        
        Swift.print("Will Activate now...??")
        
        if WCSession.default.isReachable {
            
            let message = ["getData": [:]]
            
            Swift.print("Session Is Reachable...")
            
            // Message is sent from watch, and reply us handled...
            WCSession.default.sendMessage(message, replyHandler: { (result)
                in
                
                if result["postDat"] != nil {
                    
                    Swift.print("Message result good...")
                    
                    let loadedData = result["postData"]
                    var lastArray = [] as! [Post]
                    
                    // This is where the problem is, the unarchiver doesn't work for some reason...
                    do {
                        if let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Post.self], from: loadedData as! Data) {
                            lastArray = array as! [Post]
                        }
                    } catch {
                        print("Couldn't read file.")
                    }
                    
                    // Last array is actually empty here thanks to broken unarchiver / archiver....
                    // Something is messing up somewhere...
                    self.posts = lastArray
                    
                    self.feedTable.setNumberOfRows(self.posts.count, withRowType: "FeedRow")
                    
                    // Never enters loop because the index is 0. There is no data in the array... ^
                    for(index, post) in self.posts.enumerated() {
                        
                        let row = self.feedTable.rowController(at: index) as! FeedRowController
                        
                        row.lblTitle.setText(post.title)
                        row.lblDueDate.setText(post.dueDate)
                    }
                    
                } else {
                    print("Message result was nil...")
                    
                    // Here's some test cells to make sure it works.
                    self.feedTable.setNumberOfRows(3, withRowType: "FeedRow")
                    
                    let titles : [String] = ["iOS Project", "Simple Project", "Portraits"]
                    let dates : [String] = ["2019-12-09", "2020-03-02", "2020-04-01"]
                    
                    for index in 0...2 {
                        
                        let row = self.feedTable.rowController(at: index) as! FeedRowController
                        
                        
                        row.lblTitle.setText(titles[index])
                        row.lblDueDate.setText(dates[index])
                    }
                    
                }
                
            }) { (error) in
                print(error)
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
