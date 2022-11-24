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
    var listOfFriends: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // configureNavbar()
        registerCustomTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreDataNames.entityName)
        
        do {
            listOfFriends = try managedObjectContext!.fetch(fetchRequest)
        } catch {
            fatalError(">>> ERROR Loading from Core Data \(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let index = UserDefaults.standard.integer(forKey: "FriendIndex")
        if index != -1 {
            let friend = listOfFriends[index]
            performSegue(withIdentifier: Constants.SegueNames.editFriendSegue, sender: friend)
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
    
    func registerCustomTableViewCell() {
        let cellNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.CellNames.customFriendCell)
    }
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFriends.count == 0 ? 1 : listOfFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = listOfFriends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellNames.customFriendCell, for: indexPath) as! CustomTableViewCell
        cell.userNameLabel.text = "\(friend.value(forKey: "lastName") as! String), \(friend.value(forKey: "firstName") as! String)"
        cell.locationLabel.text = "\(friend.value(forKey: "city") as! String), \(friend.value(forKey: "state") as! String)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFriend = listOfFriends[indexPath.row]
        self.performSegue(withIdentifier: Constants.SegueNames.editFriendSegue, sender: selectedFriend)
        UserDefaults.standard.set(indexPath.row, forKey: "FriendIndex")
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
            controller.delegate = self
            controller.managedObjectContext = managedObjectContext
            
        } else if (segue.identifier == Constants.SegueNames.editFriendSegue) {
            let controller = segue.destination as! AddFriendViewController
            controller.delegate = self
            controller.managedObjectContext = managedObjectContext
            controller.existingFriend = sender as? NSManagedObject
        }
    }
}

extension ViewController: AddFriendViewControllerDelegate {
    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: NSManagedObject) {
        let newRowIndex = listOfFriends.count
        listOfFriends.append(friend)
        tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .fade)

        navigationController?.popViewController(animated: true)
    }

    func addFriendViewController(_ controller: AddFriendViewController, didFinishedEditingFriend currentFriend: NSManagedObject) {
        guard let currentFriendIndex = listOfFriends.firstIndex(of: currentFriend) else { return }
        listOfFriends[currentFriendIndex] = currentFriend
        tableView.reloadRows(at: [IndexPath(row: currentFriendIndex, section: 0)], with: .fade)

        navigationController?.popViewController(animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            UserDefaults.standard.set(-1, forKey: "FriendIndex")
        }
    }
}
