//
//  MainPageController.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  FUNCTION: Sets up the main page

import UIKit
import CoreData

class MainPageController: UITableViewController {

    var container: NSPersistentContainer!
    var entries: [Entry] = []
    let dateFormatter = DateFormatter()
    let context = AppDelegate.shared.managedObjectContext
    
    @IBOutlet weak var currentDate: UILabel!
    
    lazy var dataSource: EntriesDataSource = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        return EntriesDataSource(fetchRequest: request, managedObjectContext: context, tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentDates()
        
        // Setting the values to make the tableview function correctly
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.dataSource = dataSource
        tableView.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if the segue is "createEntry", set the delegate and the context for that controller
        if segue.identifier == "createEntry" {
            let createViewController = segue.destination as? CreateEntryController
            createViewController?.delegate = self
            createViewController?.context = context
        }
    }
    
    // MARK: DELEGATE METHODS
    
    // Tableview was clicked method - Setup the createentrycontroller for editing
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = dataSource.entries[indexPath.row]
        let editEntryController = storyboard?.instantiateViewController(identifier: "CreateEntryController") as! CreateEntryController
        editEntryController.isEditingEntry = true
        editEntryController.prepareViewWith(selectedEntry)
        editEntryController.context = context
        
        self.present(editEntryController, animated: true, completion: nil)

    }
    
    // refetches the data from the datasource
    func refreshData() {
        dataSource = EntriesDataSource(fetchRequest: Entry.fetchRequest(), managedObjectContext: context, tableView: self.tableView)
    }
        
    // gets the current date and uses it throughout the view
    func setCurrentDates() {
        dateFormatter.dateStyle = .full
        let formattedDate = Array(dateFormatter.string(from: Date()).dropLast(6))
        
        currentDate.text = String(formattedDate)
        navigationItem.title = String(formattedDate)
    }
}

// When the CreateEntryController is dismissed then do these things
extension MainPageController: WasDismissedDelegate {
    func wasDismissed() {
        
        refreshData()
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
