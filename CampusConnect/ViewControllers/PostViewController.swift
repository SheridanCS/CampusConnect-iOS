//
//  PostViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-12-08.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var post : Post = Post()
    @IBOutlet var lblDueDate : UILabel!
    @IBOutlet var lblParticipants : UILabel!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var navigationBar : UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = post.title!
        navigationBar.prefersLargeTitles = false
//        navigationController?.navigationBar.topItem?.title = post.title!
//        navigationController?.navigationBar.prefersLargeTitles = false

        lblDueDate.text = post.dueDate!
        lblParticipants.text = "\(post.numOfStudents!) participant(s)"
        lblLocation.text = post.location!
        lblDescription.text = post.desc
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
