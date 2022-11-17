//
//  ViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        
        print(">>> Documents Directory: \(Persistance.getDocumentsDirectory())")
        if (dataManager.managedObjectContext != nil) {
            print(">>> SUCCESS Context is alive")
        }
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
        return dataManager.listOfFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellNames.defaultCell)
        let person = dataManager.listOfFriends[indexPath.row]
        
        var content = cell?.defaultContentConfiguration()
        content?.text = "\(person.value(forKey: "lastName")!), \(person.value(forKey: "firstName")!)"
        content?.textProperties.font = .systemFont(ofSize: 17.0)
        content?.secondaryTextProperties.font = .systemFont(ofSize: 13.0)
        content?.secondaryTextProperties.color = .black.withAlphaComponent(0.65)
        content?.image = UIImage(systemName: "person.crop.circle")
        
        cell?.contentConfiguration = content
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
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
            self.dataManager.listOfFriends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.dataManager.saveFriend()
            return
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueNames.addFriendSegue {
            let controller = segue.destination as! AddFriendViewController
            
            controller.delegate = self
            controller.managedObjectContext = dataManager.managedObjectContext
        } else if (segue.identifier == Constants.SegueNames.editFriendSegue) {
            let controller = segue.destination as! AddFriendViewController
            let path = sender as! IndexPath
            
            controller.delegate = self
            controller.managedObjectContext = dataManager.managedObjectContext
        }
    }
}

extension ViewController: AddFriendViewControllerDelegate {
    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: NSManagedObject) {
        let newRowIndex = dataManager.listOfFriends.count
        dataManager.addFriend(newFriend: friend)
        tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .fade)
        dataManager.saveFriend()
        
        navigationController?.popViewController(animated: true)
    }
    
    func addFriendViewController(_ controller: AddFriendViewController, didFinishedEditingFriend currentFriend: NSManagedObject) {
        guard let currentFriendIndex = dataManager.listOfFriends.firstIndex(of: currentFriend) else { return }
        dataManager.listOfFriends[currentFriendIndex] = currentFriend
        tableView.reloadRows(at: [IndexPath(row: currentFriendIndex, section: 0)], with: .fade)
        dataManager.saveFriend()
        
        navigationController?.popViewController(animated: true)
    }
}
