//
//  ContactInfoController.swift
//  iOSProject
//
//  Created by BW on 2023-04-12.
//

import UIKit
import SQLite3

class ContactInfoController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    
    let databaseManager = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // tap gesture with keyboard dismissal
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func validateEmailAddress(_ email: String) -> Bool {
            // regex pattern to validate email format
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
    }
        
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // regex pattern to validate phone number format
        let phoneNumberRegex = "^\\d{10}$"
        let phoneNumberPredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
        return phoneNumberPredicate.evaluate(with: phoneNumber)
    }
        
        @IBAction func SaveButton(_ sender: Any) {
            
            // Check if all fields have a value
            guard let firstName = firstNameText.text, !firstName.isEmpty,
                  let lastName = lastNameText.text, !lastName.isEmpty,
                  let emailAddress = emailAddressText.text, !emailAddress.isEmpty,
                  let address = addressText.text, !address.isEmpty,
                  let phoneNumber = phoneNumberText.text, !phoneNumber.isEmpty,
                  let notes = notesText.text, !notes.isEmpty
            else {
                // Show an alert if any field is empty
                let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Validate email format
            guard validateEmailAddress(emailAddress) else {
                let alert = UIAlertController(title: "Error", message: "Invalid email format", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Validate phone number format
            guard validatePhoneNumber(phoneNumber) else {
                let alert = UIAlertController(title: "Error", message: "Invalid phone number format", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Save the data to the database
            databaseManager.createContact(firstName: firstName, lastName: lastName, emailAddress: emailAddress, address: address, phoneNumber: phoneNumber, notes: notes)
        
            // Show a success message to the user
            let alert = UIAlertController(title: "Success", message: "Data added to database.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
