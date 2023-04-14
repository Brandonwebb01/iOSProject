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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
            let contact = contacts[indexPath.row] as! NSDictionary
               let firstName = contact.object(forKey: "firstName") as! String
               let lastName = contact.object(forKey: "lastName") as! String

        let firstNameCell = cell.viewWithTag(1) as! UILabel;
            firstNameCell.text = firstName
            
            let lastNameCell = cell.viewWithTag(2) as! UILabel;
                lastNameCell.text = lastName
            
            return cell
        }
        func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            selectedCellIndex = indexPath.row;
            self.performSegue(withIdentifier: "segueShowSelectedContact", sender: nil)
        }

}
