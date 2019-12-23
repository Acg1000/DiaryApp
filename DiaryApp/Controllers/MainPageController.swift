//
//  MainPageController.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit
import CoreData

class MainPageController: UITableViewController {

    var container: NSPersistentContainer!
    var entries: [Entry] = []
    let dateFormatter = DateFormatter()
    let context = CoreDataStack().managedObjectContext
    
    @IBOutlet weak var currentDate: UILabel!
    
    lazy var dataSource: EntriesDataSource = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        return EntriesDataSource(fetchRequest: request, managedObjectContext: context, tableView: self.tableView)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentDates()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.dataSource = dataSource
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createEntry" {
//            let createEntryController = segue.destination as? CreateEntryController
            
        }
    }
    
    
    func setCurrentDates() {
        dateFormatter.dateStyle = .full
        currentDate.text = dateFormatter.string(from: Date())
        navigationController?.title = dateFormatter.string(from: Date())
    }
    
    @IBAction func recordEntryPressed(_ sender: Any) {
//        guard let storyboard = storyboard else { return }
//
//        let createEntryController = storyboard.instantiateViewController(withIdentifier: String(describing: CreateEntryController.self)) as! CreateEntryController
//
//        let navController = UINavigationController(rootViewController: createEntryController)
//        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
//        if let text = entryTextField.text {
//
//            print("save pressed")
//
//            let _ = Entry.with(text, status: .happy, location: nil, photo: nil, in: context)
//            context.saveChanges()
//            tableView.reloadData()
//        }
    }
}
