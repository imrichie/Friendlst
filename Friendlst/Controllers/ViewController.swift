//
//  ViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext? 
    var listOfFriends: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()        
        
        if let _ = managedObjectContext {
            print(">>> SUCCESS - Passed Context to Main ViewController")
        }
        
        // load dummy data
        let name1: String = "Alisa"
        let name2: String = "Alex"
        let name3: String = "Jacob"
        
        listOfFriends.append(name1)
        listOfFriends.append(name2)
        listOfFriends.append(name3)
        
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
        if listOfFriends.count > 0 {
            return listOfFriends.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listOfFriends.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = listOfFriends[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            cell.textLabel?.text = "Cell is empty. Please Add Data"
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Constants.SegueNames.editFriendSegue, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "Remove", handler: {action, view, _ in
            self.listOfFriends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            return
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueNames.addFriendSegue {
            let controller = segue.destination as! AddFriendViewController
            controller.managedObjectContext = managedObjectContext
            
        } else if (segue.identifier == Constants.SegueNames.editFriendSegue) {
            let controller = segue.destination as! AddFriendViewController
            let path = sender as! IndexPath
            controller.managedObjectContext = managedObjectContext
        }
    }
}

//extension ViewController: AddFriendViewControllerDelegate {
//    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: NSManagedObject) {
//        let newRowIndex = dataManager.listOfFriends.count
//        dataManager.addFriend(newFriend: friend)
//        tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .fade)
//        dataManager.saveFriend()
//
//        navigationController?.popViewController(animated: true)
//    }
//
//    func addFriendViewController(_ controller: AddFriendViewController, didFinishedEditingFriend currentFriend: NSManagedObject) {
//        guard let currentFriendIndex = dataManager.listOfFriends.firstIndex(of: currentFriend) else { return }
//        dataManager.listOfFriends[currentFriendIndex] = currentFriend
//        tableView.reloadRows(at: [IndexPath(row: currentFriendIndex, section: 0)], with: .fade)
//        dataManager.saveFriend()
//
//        navigationController?.popViewController(animated: true)
//    }
//}
