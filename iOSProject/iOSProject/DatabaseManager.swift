//
//  DatabaseManager.swift
//  iOSProject
//
//  Created by BW on 2023-04-13.
//

import Foundation
import SQLite3

class DatabaseManager {
    var db: OpaquePointer?

    init() {
            // Get the path to the documents directory
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

            // Append the database name to the path
            let databasePath = docDir.appending("/database.sqlite")
            print(databasePath)
            // Create a pointer to the database object
            if sqlite3_open(databasePath, &db) != SQLITE_OK {
                print("Error opening database")
            }

            // Create the table if it does not already exist
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, emailAddress TEXT, address TEXT, phoneNumber TEXT, notes TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error creating table: \(errmsg)")
            }
           
        }

    func createContact(firstName: String, lastName: String, emailAddress: String, address: String, phoneNumber: String, notes: String) -> Bool {
        let insertStatementString = "INSERT INTO Contacts (firstName, lastName, emailAddress, address, phoneNumber, notes) VALUES (?, ?, ?, ?, ?, ?);"

        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {

            sqlite3_bind_text(insertStatement, 1, firstName, -1, nil)
            sqlite3_bind_text(insertStatement, 2, lastName, -1, nil)
            sqlite3_bind_text(insertStatement, 3, emailAddress, -1, nil)
            sqlite3_bind_text(insertStatement, 4, address, -1, nil)
            sqlite3_bind_text(insertStatement, 5, phoneNumber, -1, nil)
            sqlite3_bind_text(insertStatement, 6, notes, -1, nil)

            if sqlite3_step(insertStatement) != SQLITE_DONE {
                print("Error inserting contact")
                return false
            }
        } else {
            print("Error preparing insert statement")
            return false
        }
        print("First name: \(firstName)")
        print("Last name: \(lastName)")
        print("Email address: \(emailAddress)")
        print("Address: \(address)")
        print("Phone number: \(phoneNumber)")
        print("Notes: \(notes)")
        sqlite3_finalize(insertStatement)
        return true
    }
    
    func updateContact(id: Int, firstName: String, lastName: String, emailAddress: String, address: String, phoneNumber: String, notes: String) -> Bool {
        let updateStatementString = "UPDATE Contacts SET firstName = ?, lastName = ?, emailAddress = ?, address = ?, phoneNumber = ?, notes = ? WHERE id = ?;"

        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {

            sqlite3_bind_text(updateStatement, 1, firstName, -1, nil)
            sqlite3_bind_text(updateStatement, 2, lastName, -1, nil)
            sqlite3_bind_text(updateStatement, 3, emailAddress, -1, nil)
            sqlite3_bind_text(updateStatement, 4, address, -1, nil)
            sqlite3_bind_text(updateStatement, 5, phoneNumber, -1, nil)
            sqlite3_bind_text(updateStatement, 6, notes, -1, nil)
            sqlite3_bind_int(updateStatement, 7, Int32(id))

            if sqlite3_step(updateStatement) != SQLITE_DONE {
                print("Error updating contact")
                return false
            }
        } else {
            print("Error preparing update statement")
            return false
        }

        sqlite3_finalize(updateStatement)
        return true
    }
    
    func deleteContact(id: Int) -> Bool {
        let deleteStatementString = "DELETE FROM Contacts WHERE id = ?;"

        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))

            if sqlite3_step(deleteStatement) != SQLITE_DONE {
                print("Error deleting contact")
                return false
            }
        } else {
            print("Error preparing delete statement")
            return false
        }

        sqlite3_finalize(deleteStatement)
        return true
    }
    
    func read() -> (firstName: String, lastName: String, emailAddress: String, address: String, phone: String, notes: String) {
            var statement: OpaquePointer?
            var firstName: String?
            var lastName: String?
            var emailAddress: String?
            var address: String?
            var phoneNumber: String?
            var notes: String?

            if sqlite3_prepare_v2(db, "SELECT firstName, lastName, emailAddress, address, phoneNumber, notes FROM Contacts ORDER BY id DESC LIMIT 1", -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    firstName = String(cString: sqlite3_column_text(statement, 0))
                    lastName = String(cString: sqlite3_column_text(statement, 1))
                    emailAddress = String(cString: sqlite3_column_text(statement, 2))
                    address = String(cString: sqlite3_column_text(statement, 3))
                    phoneNumber = String(cString: sqlite3_column_text(statement, 4))
                    notes = String(cString: sqlite3_column_text(statement, 5))
                }
            }

            sqlite3_finalize(statement)

            return (firstName ?? "", lastName ?? "", emailAddress ?? "", address ?? "", phoneNumber ?? "", notes ?? "")
        }
    
        func readAll() -> NSArray {
               var statement: OpaquePointer?
               let people = [] as NSMutableArray
               
               if sqlite3_prepare_v2(db, "SELECT * from Contacts", -1, &statement, nil) == SQLITE_OK {
                   while sqlite3_step(statement) == SQLITE_ROW {
                       let id = sqlite3_column_int(statement, 0)
                       let firstName = String(cString: sqlite3_column_text(statement, 1))
                       let lastName = String(cString: sqlite3_column_text(statement, 2))
                       let emailAddress = String(cString: sqlite3_column_text(statement, 3))
                       let address = String(cString: sqlite3_column_text(statement, 4))
                       let phoneNumber = String(cString: sqlite3_column_text(statement, 5))
                       let notes = String(cString: sqlite3_column_text(statement, 6))
                       
                       let person = ["id": id, "firstName": firstName, "lastName": lastName, "emailAddress": emailAddress, "address": address, "phoneNumber": phoneNumber, "notes": notes] as [String : Any] as [String : Any]
                       people.add(person)
                   }
               }

               sqlite3_finalize(statement)

               return people
           }
}
