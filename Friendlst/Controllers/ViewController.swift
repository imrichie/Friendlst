//
//  ViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit

class ViewController: UITableViewController {
    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.loadSampleFriendData()
        configureNavbar()
    }
    
    // MARK: - Helper Functions
    func configureNavbar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemMint
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.friendsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.defaultCell)
        let person = dataManager.friendsList[indexPath.row]
        
        var content = cell?.defaultContentConfiguration()
        content?.text = "\(person.lastName), \(person.firstName)"
        content?.textProperties.font = .systemFont(ofSize: 17.0)
        content?.secondaryText = person.location
        content?.secondaryTextProperties.font = .systemFont(ofSize: 13.0)
        content?.secondaryTextProperties.color = .black.withAlphaComponent(0.65)
        content?.image = UIImage(systemName: "person.crop.circle")
        
        cell?.contentConfiguration = content
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "Remove", handler: {action, view, _ in
            print(">>> Deleting Friend")
            self.dataManager.friendsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            return
        })
        
        let editSwipeAction = UIContextualAction(style: .normal, title: "Edit", handler: {action, view, _ in
            return
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction, editSwipeAction])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueNames.addFriendSegue {
            let controller = segue.destination as! AddFriendViewController
            controller.delegate = self
        }
    }
}

extension ViewController: AddFriendViewControllerDelegate {
    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: Friend) {
        let newRowIndex = dataManager.friendsList.count
        dataManager.addFriend(newFriend: friend)
        tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .fade)
        
        navigationController?.popViewController(animated: true)
    }
}
