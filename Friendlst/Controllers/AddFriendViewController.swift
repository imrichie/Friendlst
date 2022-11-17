//
//  AddFriendViewController.swift
//  Friendlst
//
//  Created by Richie Flores on 10/31/22.
//

import UIKit
import CoreData

protocol AddFriendViewControllerDelegate: AnyObject {
    func addFriendViewController(_ controller: AddFriendViewController, didFinishAddingFriend friend: NSManagedObject)
    func addFriendViewController(_ controller: AddFriendViewController, didFinishedEditingFriend currentFriend: NSManagedObject)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewDelegates()
        
        if let _ = managedObjectContext {
            print(">>> SUCCESS - Passed Context to Detail ViewController")
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
        
        let friend = Friend(context: managedObjectContext!)
        friend.firstName = firstNameText.text!
        friend.lastName = lastNameText.text!
        friend.city = cityText.text!
        friend.state = stateText.text!
        friend.email = emailText.text ?? ""
        friend.phoneNumber = phoneText.text ?? ""
        friend.comments = commentsTextView.text ?? ""
        
        do {
            try managedObjectContext!.save()
            navigationController?.popViewController(animated: true)
        } catch {
            fatalError(">>> ERROR Saving data to Core Data: \(error.localizedDescription)")
        }
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
