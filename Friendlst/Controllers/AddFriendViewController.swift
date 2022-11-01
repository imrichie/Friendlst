//
//  AddFriendViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/31/22.
//

import UIKit

class AddFriendViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 1
        }
    }

}
