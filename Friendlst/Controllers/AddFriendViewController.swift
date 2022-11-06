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
    
    // MARK: - Event Handlers
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        guard firstNameText.isValid() else { presentAlertController(entry: "First name"); return }
        guard lastNameText.isValid() else { presentAlertController(entry: "Last name"); return }
        guard cityText.isValid() else { presentAlertController(entry: "City"); return }
        guard stateText.isValid() else { presentAlertController(entry: "State"); return }
        
        let newFriend: Friend = Friend()
        newFriend.firstName = firstNameText.text!
        newFriend.lastName = lastNameText.text!
        newFriend.location = "\(cityText.text!), \(stateText.text!)"
        
        if let delegate = delegate {
            delegate.addFriendViewController(self, didFinishAddingFriend: newFriend)
        }
        
        navigationController?.popViewController(animated: true)
    }

    // MARK: - TableView Data Source
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
    
    // MARK: - Private Functions
    func isTextFieldEntriesValid() -> Bool {
        return true
    }
    
    func presentAlertController(entry: String) {
        let alert = UIAlertController(title: "Oops", message: "\(entry) is a required field", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - Extensions
extension UITextField {
    func isValid() -> Bool {
        guard let text = text, !text.isEmpty else { return false }
        
        return true
    }
}
