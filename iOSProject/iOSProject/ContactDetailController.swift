//
//  ContactDetailController.swift
//  iOSProject
//
//  Created by BW on 2023-04-14.
//

import UIKit

class ContactDetailController: UIViewController {

    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    
    
    
    
    var contact: (firstName: String, lastName: String, emailAddress: String, address: String, phoneNumber: String, notes: String)?
    let databaseManager = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call read() function on databaseManager instance to fetch data
        contact = databaseManager.read()

        // Update UI with fetched data
        firstNameText.text = contact?.firstName
        lastNameText.text = contact?.lastName
        emailAddressText.text = contact?.emailAddress
        addressText.text = contact?.address
        phoneNumberText.text = contact?.phoneNumber
        notesText.text = contact?.notes
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func SaveButton(_ sender: Any) {
    }
    @IBAction func EditButton(_ sender: Any) {
    }
    @IBAction func DeleteButton(_ sender: Any) {
        guard let id = databaseManager.getContactId(firstName: contact?.firstName ?? "", lastName: contact?.lastName ?? "") else {
                print("Error getting contact id")
                return
            }
            
            if databaseManager.deleteContact(id: id) {
                let alert = UIAlertController(title: "Success", message: "Contact deleted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Error deleting contact.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
