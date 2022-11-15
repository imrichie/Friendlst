//
//  AddFriendViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/31/22.
//

import UIKit
import CoreData

protocol AddFriendViewControllerDelegate: AnyObject {
    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: Friends)
    func addFriendViewController(_ controller: AddFriendViewController, didFinishedEditingFriend currentFriend: Friends)
}

class AddFriendViewController: UITableViewController {
    
    @IBOutlet weak var firstNameText: UITextField!    
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var commentsTextView: UITextView!
    
    weak var delegate: AddFriendViewControllerDelegate?
    weak var managedObjectContext: NSManagedObjectContext?
    weak var existingFriend: Friends?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewDelegates()
        
        if let _ = managedObjectContext {
            print(">>> SUCCESS PASSED THE OBJECT CONTEXT")
        }
        
        if let friendToEdit = existingFriend {
            self.title = "Edit Friend"
            let city = friendToEdit.location.split(separator: ",")
            firstNameText.text = friendToEdit.firstName
            lastNameText.text = friendToEdit.lastName
            cityText.text = "\(city[0])"
            stateText.text = "\(city[1].dropFirst())"
            
            emailText.text = friendToEdit.email
            phoneText.text = friendToEdit.phoneNumber
            
            commentsTextView.text = friendToEdit.comments
        }
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
        
        if let context = managedObjectContext {
            let friend = Friend(context: context)
            friend.firstName = firstNameText.text!
            friend.lastName = lastNameText.text!
            friend.city = cityText.text!
            friend.state = stateText.text!
            friend.email = emailText.text ?? ""
            friend.phoneNumber = phoneText.text ?? ""
            friend.comments = commentsTextView.text ?? ""
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print(">>> ERROR SAVING TO CORE DATE: \(error.localizedDescription)")
            }
        }
        
//        if let existingFriend = existingFriend {
//            existingFriend.firstName = firstNameText.text!
//            existingFriend.lastName = lastNameText.text!
//            existingFriend.location = "\(cityText.text!), \(stateText.text!)"
//            existingFriend.email = emailText.text ?? ""
//            existingFriend.phoneNumber = phoneText.text ?? ""
//            existingFriend.comments = commentsTextView.text ?? ""
//
//            delegate?.addFriendViewController(self, didFinishedEditingFriend: existingFriend)
//        } else {
//            let newFriend: Friends = Friends()
//            newFriend.firstName = firstNameText.text!
//            newFriend.lastName = lastNameText.text!
//            newFriend.location = "\(cityText.text!), \(stateText.text!)"
//            newFriend.email = emailText.text ?? ""
//            newFriend.phoneNumber = phoneText.text ?? ""
//            newFriend.comments = commentsTextView.text ?? ""
//
//            delegate?.addFriendViewController(self, didFinishAddingFriend: newFriend)
//        }
    }

    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    // MARK: - Private Functions
    func presentAlertController(entry: String) {
        let alert = UIAlertController(title: "Oops", message: "\(entry) is a required field", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func setTextViewDelegates() {
        firstNameText.delegate = self
        lastNameText.delegate = self
        cityText.delegate = self
        stateText.delegate = self
        emailText.delegate = self
        phoneText.delegate = self
    }
}

// MARK: - Extensions
extension UITextField {
    func isValid() -> Bool {
        guard let text = text, !text.isEmpty else { return false }
        return true
    }
}

extension AddFriendViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameText || textField == lastNameText || textField == cityText {
            let allowedCharacter = CharacterSet.letters
            let allowedCharacter1 = CharacterSet.whitespaces
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
        } else if textField == stateText {
            let allowedCharacter = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= 2 && allowedCharacter.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameText:
            lastNameText.becomeFirstResponder()
        case lastNameText:
            cityText.becomeFirstResponder()
        case cityText:
            stateText.becomeFirstResponder()
        case stateText:
            commentsTextView.becomeFirstResponder()
        default:
            commentsTextView.becomeFirstResponder()
        }
        return true
    }
}
