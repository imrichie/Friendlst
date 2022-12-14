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
    @IBOutlet weak var commentsText: UITextView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    weak var delegate: AddFriendViewControllerDelegate?

    var existingFriend: NSManagedObject?
    var dataManager: DataManager!
    var photoData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewDelegates()
        
        if let friendToEdit = existingFriend {
            self.title = "Edit Friend"
            self.addPhotoLabel.text = "Change Picture"
            
            firstNameText.text = friendToEdit.value(forKey: "firstName") as? String
            lastNameText.text = friendToEdit.value(forKey: "lastName") as? String
            cityText.text = friendToEdit.value(forKey: "city") as? String
            stateText.text = friendToEdit.value(forKey: "state") as? String
            emailText.text = friendToEdit.value(forKey: "email") as? String
            phoneText.text = friendToEdit.value(forKey: "phoneNumber") as? String
            commentsText.text = friendToEdit.value(forKey: "comments") as? String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameText.becomeFirstResponder()
    }
    
    // MARK: - Event Handlers
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        guard firstNameText.isValid() else { presentAlertController(entry: "First name is a required field"); return }
        guard lastNameText.isValid() else { presentAlertController(entry: "Last name is a required field"); return }
        guard cityText.isValid() else { presentAlertController(entry: "City is a required field"); return }
        guard stateText.isValid() else { presentAlertController(entry: "State is a required field"); return }
        
        
        if phoneText.text!.count > 1 && phoneText.text!.count < 14 {
            presentAlertController(entry: "Invalid Phone Number\n(XXX) XXX-XXXX")
        }
        
        
        if let existingFriend = existingFriend {
            existingFriend.setValue(firstNameText.text, forKey: "firstName")
            existingFriend.setValue(lastNameText.text, forKey: "lastName")
            existingFriend.setValue(cityText.text, forKey: "city")
            existingFriend.setValue(stateText.text, forKey: "state")
            existingFriend.setValue(emailText.text, forKey: "email")
            existingFriend.setValue(phoneText.text, forKey: "phoneNumber")
            existingFriend.setValue(commentsText.text, forKey: "comments")
            existingFriend.setValue(photoData, forKey: "profilePhoto")
            
            dataManager.saveData()
            delegate?.addFriendViewController(self, didFinishedEditingFriend: existingFriend)
            
        } else {
            let friend = Friend(context: dataManager.managedObjectContext)
            friend.firstName = firstNameText.text!
            friend.lastName = lastNameText.text!
            friend.city = cityText.text!
            friend.state = stateText.text!
            friend.email = emailText.text ?? ""
            friend.phoneNumber = phoneText.text ?? ""
            friend.comments = commentsText.text ?? ""
            friend.profilePhoto = photoData
            
            dataManager.saveData()
            delegate?.addFriendViewController(self, didFinishAddingFriend: friend)
        }
    }

    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle any photo libray/camera logic
        if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            showPhotoMenu()
        }
    }
    
    // MARK: - Private Functions
    func presentAlertController(entry: String) {
        let alert = UIAlertController(title: "Oops", message: "\(entry)", preferredStyle: .alert)
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
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                // just append a mask character
                result.append(ch)
            }
        }
        return result
    }
    
    func chooseFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionCancel)
        
        let actionPhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.takePhotoWithCamera()
        }
        alert.addAction(actionPhoto)
        
        let actionLibrary = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.chooseFromLibrary()
        }
        alert.addAction(actionLibrary)
        
        present(alert, animated: true)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            chooseFromLibrary()
        }
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
        } else if textField == phoneText {
            let newString = (phoneText.text! as NSString).replacingCharacters(in: range, with: string)
            phoneText.text = format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
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
            commentsText.becomeFirstResponder()
        default:
            commentsText.becomeFirstResponder()
        }
        return true
    }
}

extension AddFriendViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let profilePic = info[.editedImage] as? UIImage {
            if let photoData = profilePic.pngData() {
                print(">>> SUCCESS - Transformed User Pic to Data type: \(photoData)")
                self.photoData = photoData
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
