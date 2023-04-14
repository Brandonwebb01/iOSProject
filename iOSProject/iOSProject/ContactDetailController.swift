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
    }
    
    
    @IBAction func SaveButton(_ sender: Any) {
    }
    @IBAction func EditButton(_ sender: Any) {
    }
    @IBAction func DeleteButton(_ sender: Any) {
    }
    @IBAction func CloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
