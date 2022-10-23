//
//  ViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit

class ViewController: UITableViewController {
    let dataManager = SamplePersonManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.loadData()
        configureNavbar()
        registerTableViewCells()
    }
    
    // MARK: - Helper Functions
    func configureNavbar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemMint
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func registerTableViewCells() {
        let personCell = UINib(nibName: "FriendTableViewCell", bundle: nil)
        self.tableView.register(personCell, forCellReuseIdentifier: CellNames.friendCell)
    }
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = dataManager.persons[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.friendCell) as! FriendTableViewCell
        cell.nameLabel.text = "\(friend.lastName), \(friend.firstName)"
        cell.cityLabel.text = friend.city
        cell.birthdayLabel.text = "\(friend.birthDate)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.persons.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
