//
//  ContactInfoController.swift
//  iOSProject
//
//  Created by BW on 2023-04-12.
//

import UIKit
import SQLite3

class ContactInfoController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var notesText: UITextView!
    
    
    var db: OpaquePointer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let path = Bundle.main.path(forResource: "myDatabase", ofType: "db") {
            if sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
                // Database opened successfully
            } else {
                print("Error opening database")
            }
        } else {
            print("myDatabase.db file not found in app bundle")
        }
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        
        let insertStatementString = "INSERT INTO Contacts (firstName, lastName, emailAddress, address, phoneNumber, notes) VALUES (?, ?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, firstNameText.text, -1, nil)
            sqlite3_bind_text(insertStatement, 2, lastNameText.text, -1, nil)
            sqlite3_bind_text(insertStatement, 3, emailAddressText.text, -1, nil)
            sqlite3_bind_text(insertStatement, 4, addressText.text, -1, nil)
            sqlite3_bind_text(insertStatement, 5, phoneNumberText.text, -1, nil)
            sqlite3_bind_text(insertStatement, 6, notesText.text ?? "", -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                        print("Successfully inserted row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error inserting row: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
}
