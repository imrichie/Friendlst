//
//  AddFriendViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/31/22.
//

import UIKit

protocol AddFriendViewControllerDelegate: AnyObject {
    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: Friend)
}

class AddFriendViewController: UITableViewController {
    
    @IBOutlet weak var firstNameText: UITextField!    
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    
    weak var delegate: AddFriendViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameText.becomeFirstResponder()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        guard let firstName = firstNameText.text else { return }
        guard let lastName = lastNameText.text else { return }
        guard let city = cityText.text else { return }
        guard let state = stateText.text else { return }
        
        let newFriend = Friend()
        newFriend.firstName = firstName
        newFriend.lastName = lastName
        newFriend.location = "\(city), \(state)"
        
        if let delegate = delegate {
            delegate.addFriendViewController(self, didFinishAddingFriend: newFriend)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
}
