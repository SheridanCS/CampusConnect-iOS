//
//  MessagesTableViewController.swift
//  CampusConnect
//
//  Created by Timothy Catibog on 2019-11-19.
//  Copyright © 2019 PROG31975. All rights reserved.
//

import UIKit

class ChatListViewController: UITableViewController {
    @IBOutlet var myTable : UITableView!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer : Timer!

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true);
       }

       @objc func refreshTable(){
        if(mainDelegate.people.count > 0){
               self.myTable.reloadData()
               self.timer.invalidate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.people.count
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableCell : SiteCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell (style: .default, reuseIdentifier: "cell")

        let rowNum = indexPath.row
        tableCell.primaryLabel.text = mainDelegate.people[rowNum].name
        print("here:", mainDelegate.people[rowNum].name)
        return tableCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = mainDelegate.people[indexPath.row]
        print("selected: ", friend.name)

        let vc = ChatViewController()
        vc.friend = friend

        self.navigationController?.pushViewController(vc, animated: true)
    }
}
