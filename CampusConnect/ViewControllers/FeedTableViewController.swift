//
//  FeedTableViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit

import Firebase
import FirebaseFirestore

import WatchConnectivity


 // This is the Table Cell
class FeedTableViewCell : UITableViewCell {
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDueDateLabel: UILabel!
    @IBOutlet weak var postDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

class FeedTableViewController: UITableViewController, WCSessionDelegate {
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var posts : [Post] = []
    var selectedPost : Int = 0
    
    var watchFeed : [Post] = []
    
    @IBOutlet var myTableView: UITableView!
    @IBAction func unwindToFeed(sender: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initiate Conncetion from phone to watch
        if WCSession.isSupported() {
            
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.posts.removeAll()
        initDetails()
        
        //Initiate Conncetion from phone to watch
        if WCSession.isSupported() {
            
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - Table view data source

    // Table Stuff
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedTableViewCell ?? FeedTableViewCell(style: .default, reuseIdentifier: "FeedCell")
        
        let rowNum = indexPath.row
        tableCell.postTitleLabel.text = posts[rowNum].title
        tableCell.postDescLabel.text = posts[rowNum].desc
        tableCell.postDueDateLabel.text = posts[rowNum].dueDate

        return tableCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = indexPath.row
        performSegue(withIdentifier: "ShowSinglePostSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowSinglePostSegue") {
            let vc: PostViewController = segue.destination as! PostViewController
            vc.post = self.posts[selectedPost]
        }
    }
    
    // Grabbing the data from database...
    
    var lat : Double?
    var lon : Double?
    
    func initDetails() {
        let db = mainDelegate.firestoreDB!
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let title = document.get("project_title") as! String
                    let dueDate = document.get("due_date") as! String
                    
                    let desc = document.get("project_desc") as! String
                    let num = document.get("num_of_students") as! Int
                    
                    // This is for later... it 's the data from the geo point.
                    // Will need to work with this to impliment "View Post" later althrough it's not needed here...
                    if let coords = document.get("location") {
                        let point = coords as! GeoPoint
                        self.lat = point.latitude
                        self.lon = point.longitude
                    }
                    
                    let postObj = Post()
                    postObj.initWithData(title: title, dueDate: dueDate, desc: desc, numOfStudents: num, location: "PlaceHolder")
                    
                    let watchPostObj = Post()
                    watchPostObj.initWithLessData(title: title, dueDate: dueDate)
                    
                    
                    self.posts.append(postObj)
                    self.watchFeed.append(postObj)
                    
                    self.myTableView.reloadData();
                }
            }
        }
    }
    
    // Watch Stuff
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        Swift.print("did receive messsage")
        
        var replyValues = Dictionary<String, AnyObject>()
        
        NSKeyedArchiver.setClassName("Post", for: Post.self)
        
        let progData = try?
            NSKeyedArchiver.archivedData(withRootObject: watchFeed, requiringSecureCoding: false)
        
        replyValues["postData"] = progData as AnyObject?
        replyHandler(replyValues)
            
    }
    
    // Watch Stuff
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
