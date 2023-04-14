//
//  TableViewController.swift
//  iOSProject
//
//  Created by BW on 2023-04-12.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    
    var contacts = [] as NSArray;
    var selectedCellIndex: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.dataSource = self;
        TableView.delegate = self;
        // Do any additional setup after loading the view.
        // Fetch data from database
        let databaseManager = DatabaseManager()
        contacts = databaseManager.readAll() as NSArray // assuming readAll() method returns an array of contacts
        print(contacts)
        // Reload table view data
        TableView.reloadData()
    // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = contacts[indexPath.row] as! NSDictionary
        let firstName = contact.object(forKey: "firstName") as! String
        let lastName = contact.object(forKey: "lastName") as! String

        let firstNameCell = cell.viewWithTag(1) as! UILabel
        firstNameCell.text = firstName

        let lastNameCell = cell.viewWithTag(2) as! UILabel
        lastNameCell.text = lastName

        return cell
    }
        func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            selectedCellIndex = indexPath.row;
            self.performSegue(withIdentifier: "ShowSelectedContact", sender: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "ShowSelectedContact") {
                let vc = segue.destination as! ContactDetailController
                let selectedContact = contacts[selectedCellIndex] as! NSDictionary
                
                vc.firstNameText.text = selectedContact.object(forKey: "firstName") as? String
                vc.lastNameText.text = selectedContact.object(forKey: "lastName") as? String
                vc.emailAddressText.text = selectedContact.object(forKey: "emailAddress") as? String
                vc.addressText.text = selectedContact.object(forKey: "address") as? String
                vc.phoneNumberText.text = selectedContact.object(forKey: "phoneNumber") as? String
                vc.notesText.text = selectedContact.object(forKey: "notes") as? String
            }
        }

}
